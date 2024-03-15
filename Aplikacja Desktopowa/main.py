from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.clock import Clock
from datetime import datetime

from kivy.uix.textinput import TextInput
from smartcard.System import readers
from smartcard.util import toHexString
from kivy.uix.image import Image
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.popup import Popup
import os, sys
from kivy.resources import resource_add_path
from kivy.core.window import Window


class ImageLabel(FloatLayout):
    def __init__(self, image_path, text, **kwargs):
        super(ImageLabel, self).__init__(**kwargs)

        # Add an image as background
        self.image = Image(source=image_path, allow_stretch=True, keep_ratio=False)
        self.image.size_hint = (1, 1)
        self.image.pos_hint = {'x': 0, 'y': 0}
        self.add_widget(self.image)

        # Overlay a label on the image
        self.label = Label(text=text,
                           size_hint=(0.8, 0.4),
                           halign='center',
                           valign='middle')
        self.label.outline_color = (1, 0, 0, 0.5)
        self.label.outline_width = 1
        self.label.color = (300, 300, 300, 0.9)
        self.label.pos_hint = {'center_x': 0.5, 'center_y': 0.65}
        self.add_widget(self.label)

        # Bind size to update font size dynamically
        self.label.bind(size=self.adjust_font_size)

    def adjust_font_size(self, instance, value):
        # Adjust font size based on the height of the label
        instance.font_size = 0.5 * instance.height  # Example scaling factor
        instance.text_size = instance.size  # Update text size for proper wrapping


class CardGrid(GridLayout):
    def __init__(self, **kwargs):
        super(CardGrid, self).__init__(**kwargs)
        self.cols = 5
        self.card_timers = {}
        self.init_grid()
        self.nfc_reader = self.connect_reader()
        self.card_uid = None

    def init_grid(self):
        image_path = MyApp.resource_path("roll3.png")
        img_label = ImageLabel(image_path=image_path, text="SKATEPARK")
        self.add_widget(img_label)

    def check_nfc_card(self, dt):
        card_uid = self.read_card(self.nfc_reader)
        if card_uid and self.card_uid == None:
            # Handle card based on its current state
            self.card_uid = card_uid
            self.handle_card_state(card_uid)

    def handle_card_state(self, card_uid):
        popup = Popup(title='Udało się odczytać kartę!',
                      content=BoxLayout(orientation='vertical'),
                      size_hint=(None, None), size=(400, 400))

        popup.background_color = (0, 1, 0, 1)

        popup.content.add_widget(Label(text=f"UID: {card_uid}"))

        close_button = Button(text='Zamknij', on_press=popup.dismiss, size_hint=(None, None), size=(100, 50),
                              pos_hint={'center_x': 0.5, 'y': 0})
        popup.content.add_widget(close_button)
        popup.bind(on_dismiss=self.reset_card_uid)
        popup.open()
        return

    def reset_card_uid(self, *args):
        self.card_uid = None

    def connect_reader(self):
        """ Establish a connection with the NFC reader. """
        try:
            # Get the list of available readers
            r = readers()
            if not r:
                # print("No NFC readers detected.")
                return None
            # Assuming the first reader is the one we want to use
            reader = r[0]

            # Establish connection
            connection = reader.createConnection()
            connection.connect()

            return connection
        except Exception as e:
            return None

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


class MyApp(App):
    def build(self):
        Window.size = (900, 600)

        main_layout = BoxLayout(orientation='vertical')

        grid = CardGrid()
        main_layout.add_widget(grid)

        Clock.schedule_interval(grid.check_nfc_card, 0.08)

        return main_layout

    @staticmethod
    def resource_path(relative_path):
        try:
            base_path = sys._MEIPASS
        except Exception:
            base_path = os.path.abspath('.')
        return os.path.join(base_path, relative_path)


if __name__ == '__main__':
    if hasattr(sys, '_MEIPASS'):
        resource_add_path((os.path.join(sys._MEIPASS)))

    MyApp().run()
