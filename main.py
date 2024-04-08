from kivy.app import App
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.label import Label
from kivy.clock import Clock
from kivy.uix.image import Image
from kivy.uix.button import Button
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.graphics import Color, Rectangle
import os
import sys
from kivy.resources import resource_add_path
from kivy.core.window import Window
from smartcard.System import readers
from smartcard.util import toHexString
from smartcard.util import toASCIIString
from database.zapisz import *
from database.czytanie import *



class CardGrid(FloatLayout):
    def __init__(self, **kwargs):
        super(CardGrid, self).__init__(**kwargs)
        self.nfc_reader = self.connect_reader()
        self.card_uid = None
        self.init_grid()
        Clock.schedule_interval(self.check_nfc_card, 0.08)

    def init_grid(self):
        # Load the background image
        background_image = Image(source="tlo.jpg", allow_stretch=True, keep_ratio=False)
        self.add_widget(background_image)

        # Create the label for "NFC WEJŚCIÓWKI" text with a white color
        img_label_white = Label(text="NFC WEJŚCIÓWKI", size_hint=(None, None), size=(600, 200), pos_hint={'center_x': 0.5, 'center_y': 0.5})
        img_label_white.color = (1, 1, 1, 1)  # Set text color to white
        img_label_white.font_size = 50
        self.add_widget(img_label_white)

        # Add black rectangle behind the white text label
        with img_label_white.canvas.before:
            Color(0, 0, 0, 1)  # Black color
            self.black_rect = Rectangle(pos=(135, 250), size=(img_label_white.width + 10, img_label_white.height-100))

    def connect_reader(self):
        """ Establish a connection with the NFC reader. """
        try:
            # Get the list of available readers
            r = readers()
           # if not r:
           #     print("No NFC readers detected.")
             #   return None
           # else:
           #     print("Available NFC reader(s):")
            #    for idx, reader in enumerate(r):
            #        print(f"{idx + 1}. {reader}")

            # Assuming the first reader is the one we want to use
            reader = r[0]

            # Establish connection
            connection = reader.createConnection()
            connection.connect()

            return connection
        except Exception as e:
            print("Error:", e)
            return None

    def check_nfc_card(self, dt):
        card_uid = self.read_card(self.nfc_reader)
        if card_uid and self.card_uid is None:
            # Handle card based on its current state
            self.card_uid = card_uid
            self.handle_card_state(card_uid)

    def handle_card_state(self, card_uid):
        popup = Popup(title='Udało się odczytać kartę!', size_hint=(None, None), size=(400, 400))
        popup.background_color = (0, 1, 0, 1)

        content_layout = BoxLayout(orientation='vertical')
        popup.content = content_layout

        # Display UID
        content_layout.add_widget(Label(text=f"UID: {card_uid}"))

        name, surname = wypisz_osobe_o_danym_uid(card_uid)
        if name is not None and surname is not None:
            popup.content.add_widget(Label(text=f"Imię: {name}"))
            popup.content.add_widget(Label(text=f"Nazwisko: {surname}"))
        else:
            popup.content.add_widget(Label(text="Brak osoby o podanym UID"))

        # Read text data from the card
        text_data = self.read_text_data_alternative(card_uid)
        if text_data:
            content_layout.add_widget(Label(text=f"Text on card: {text_data}"))
        else:
            content_layout.add_widget(Label(text="Failed to read text data from the card."))

        close_button = Button(text='Zamknij', on_press=popup.dismiss, size_hint=(None, None), size=(100, 50),
                              pos_hint={'center_x': 0.5, 'y': 0})
        content_layout.add_widget(close_button)

        popup.bind(on_dismiss=self.reset_card_uid)
        popup.open()

    def reset_card_uid(self, *args):
        self.card_uid = None

    def read_card(self, connection):
        """ Read data from an NFC card using the provided connection. """
        if not connection:
            connection = self.connect_reader()

        try:
            # Example command to get the UID of an ISO14443A card
            command = [0xFF, 0xCA, 0x00, 0x00, 0x00]

            # Send command and receive the response
            data, sw1, sw2 = connection.transmit(command)

            # Check the status words
            if sw1 == 0x90 and sw2 == 0x00:
                # Successful response
                uid = toHexString(data)
                return uid
            else:
                # Error in response
                print(f"Failed to read card: SW1={sw1:02X}, SW2={sw2:02X}")
                return None

        except Exception as e:
            return None

    def read_text_data_alternative(self, card_uid):
        """ Read text data from an NFC card using an alternative method (direct APDU commands). """
        if not self.nfc_reader:
            return None

        try:
            # Select the NDEF Application on the NFC card
            select_ndef_app_command = [0x00, 0xA4, 0x04, 0x00, 0x07, 0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01]
            _, sw1, sw2 = self.nfc_reader.transmit(select_ndef_app_command)

            # Check the status words
            if sw1 != 0x90 or sw2 != 0x00:
                print(f"Failed to select NDEF Application: SW1={sw1:02X}, SW2={sw2:02X}")
                return None

            # Read the NDEF records from the NFC card
            read_ndef_records_command = [0x00, 0xB0, 0x00, 0x00, 0xFF]
            data, sw1, sw2 = self.nfc_reader.transmit(read_ndef_records_command)

            # Check the status words
            if sw1 == 0x90 and sw2 == 0x00:
                # Successful response
                # Parse the NDEF records to extract text data
                text_data = self.parse_ndef_records(data)
                return text_data
            else:
                # Error in response
                print(f"Failed to read NDEF records from the card: SW1={sw1:02X}, SW2={sw2:02X}")
                return None

        except Exception as e:
            print("Error:", e)
            return None
    def read_text_data(self, card_uid):
        """ Read text data from an NFC card using the provided UID. """
        if not self.nfc_reader:
            return None

        try:
            # Example command to read NDEF records from an NFC card
            command = [0xFF, 0xB0, 0x00, 0x04, 0x10]

            # Send command and receive the response
            data, sw1, sw2 = self.nfc_reader.transmit(command)

            # Check the status words
            if sw1 == 0x90 and sw2 == 0x00:
                # Successful response
                # Assuming the data is UTF-8 encoded text
                text_data = toASCIIString(data)
                return text_data
            else:
                # Error in response
                print(f"Failed to read text data from the card: SW1={sw1:02X}, SW2={sw2:02X}")
                return None

        except Exception as e:
            print("Error:", e)
            return None





def parse_ndef_records(self, data):
    """ Parse NDEF records to extract text data. """
    # The structure of NDEF records may vary, implement parsing logic based on your card's NDEF format
    # Here's a simple example assuming the first record is a Text Record
    if len(data) > 3 and data[0] == 0xD1 and data[1] == 0x01:
        text_length = data[2]
        text_data = data[3:3 + text_length].decode('utf-8')
        return text_data
    else:
        print("No Text Record found in NDEF message")
        return None


class MyApp(App):
    def build(self):
        Window.size = (900, 600)

        main_layout = FloatLayout()

        grid = CardGrid()
        main_layout.add_widget(grid)

        return main_layout


if __name__ == '__main__':
    if hasattr(sys, '_MEIPASS'):
        resource_add_path((os.path.join(sys._MEIPASS)))

    cred = credentials.Certificate("database/serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
    })

    MyApp().run()
