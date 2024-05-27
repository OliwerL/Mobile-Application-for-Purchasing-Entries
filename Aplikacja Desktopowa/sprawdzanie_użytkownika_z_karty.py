import sys
import time
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget, QHBoxLayout, QGridLayout, QGroupBox, QPushButton, QMessageBox
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import QTimer
from smartcard.System import readers
from smartcard.util import toHexString

# Import Firebase admin SDK
import firebase_admin
from firebase_admin import credentials, firestore

from read_data_from_all_sectors import read_data_from_all_card_sectors

# Initialize Firebase
cred = credentials.Certificate("asd.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
})
db = firestore.client()

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("NFC WEJŚCIÓWKI")
        self.setGeometry(100, 100, 900, 600)

        self.nfc_reader = self.connect_reader()
        self.card_uid = None
        self.user_data = None  # To store user data

        self.init_ui()
        self.timer = QTimer()
        self.timer.timeout.connect(self.check_nfc_card)
        self.timer.start(80)

    def init_ui(self):
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout = QVBoxLayout(self.central_widget)

        # Create the grid layout for displaying user data
        self.data_layout = QGridLayout()
        self.layout.addLayout(self.data_layout)

        self.name_group = QGroupBox("Name and Email")
        self.coins_group = QGroupBox("Coins")
        self.karnety_group = QGroupBox("Karnety")

        self.name_layout = QVBoxLayout()
        self.coins_layout = QVBoxLayout()
        self.karnety_layout = QVBoxLayout()

        self.name_label = QLabel("Name: \nEmail: ")
        self.coins_label = QLabel("Coins: ")
        self.karnet_1h_label = QLabel("Karnet_1h: ")
        self.karnet_4h_label = QLabel("Karnet_4h: ")
        self.karnet_8h_label = QLabel("Karnet_8h: ")
        self.karnet_open_label = QLabel("Karnet_Open: ")

        self.coins_buttons = QHBoxLayout()
        self.karnet_1h_buttons = QHBoxLayout()
        self.karnet_4h_buttons = QHBoxLayout()
        self.karnet_8h_buttons = QHBoxLayout()
        self.karnet_open_buttons = QHBoxLayout()

        self.coins_add_button = QPushButton("dodaj")
        self.coins_remove_button = QPushButton("usun")
        self.karnet_1h_add_button = QPushButton("dodaj")
        self.karnet_1h_remove_button = QPushButton("usun")
        self.karnet_4h_add_button = QPushButton("dodaj")
        self.karnet_4h_remove_button = QPushButton("usun")
        self.karnet_8h_add_button = QPushButton("dodaj")
        self.karnet_8h_remove_button = QPushButton("usun")
        self.karnet_open_add_button = QPushButton("dodaj")
        self.karnet_open_remove_button = QPushButton("usun")

        self.coins_buttons.addWidget(self.coins_label)
        self.coins_buttons.addWidget(self.coins_add_button)
        self.coins_buttons.addWidget(self.coins_remove_button)

        self.karnet_1h_buttons.addWidget(self.karnet_1h_label)
        self.karnet_1h_buttons.addWidget(self.karnet_1h_add_button)
        self.karnet_1h_buttons.addWidget(self.karnet_1h_remove_button)

        self.karnet_4h_buttons.addWidget(self.karnet_4h_label)
        self.karnet_4h_buttons.addWidget(self.karnet_4h_add_button)
        self.karnet_4h_buttons.addWidget(self.karnet_4h_remove_button)

        self.karnet_8h_buttons.addWidget(self.karnet_8h_label)
        self.karnet_8h_buttons.addWidget(self.karnet_8h_add_button)
        self.karnet_8h_buttons.addWidget(self.karnet_8h_remove_button)

        self.karnet_open_buttons.addWidget(self.karnet_open_label)
        self.karnet_open_buttons.addWidget(self.karnet_open_add_button)
        self.karnet_open_buttons.addWidget(self.karnet_open_remove_button)

        self.name_layout.addWidget(self.name_label)
        self.coins_layout.addLayout(self.coins_buttons)
        self.karnety_layout.addLayout(self.karnet_1h_buttons)
        self.karnety_layout.addLayout(self.karnet_4h_buttons)
        self.karnety_layout.addLayout(self.karnet_8h_buttons)
        self.karnety_layout.addLayout(self.karnet_open_buttons)

        self.name_group.setLayout(self.name_layout)
        self.coins_group.setLayout(self.coins_layout)
        self.karnety_group.setLayout(self.karnety_layout)

        self.data_layout.addWidget(self.name_group, 0, 0)
        self.data_layout.addWidget(self.coins_group, 1, 0)
        self.data_layout.addWidget(self.karnety_group, 2, 0)

        # Connect buttons to methods
        self.coins_add_button.clicked.connect(lambda: self.update_field('coins', 1))
        self.coins_remove_button.clicked.connect(lambda: self.update_field('coins', -1))
        self.karnet_1h_add_button.clicked.connect(lambda: self.update_field('Karnet_1h', 1))
        self.karnet_1h_remove_button.clicked.connect(lambda: self.update_field('Karnet_1h', -1))
        self.karnet_4h_add_button.clicked.connect(lambda: self.update_field('Karnet_4h', 1))
        self.karnet_4h_remove_button.clicked.connect(lambda: self.update_field('Karnet_4h', -1))
        self.karnet_8h_add_button.clicked.connect(lambda: self.update_field('Karnet_8h', 1))
        self.karnet_8h_remove_button.clicked.connect(lambda: self.update_field('Karnet_8h', -1))
        self.karnet_open_add_button.clicked.connect(lambda: self.update_field('Karnet_Open', 1))
        self.karnet_open_remove_button.clicked.connect(lambda: self.update_field('Karnet_Open', -1))

    def connect_reader(self):
        """ Establish a connection with the NFC reader. """
        try:
            r = readers()
            if not r:
                print("No NFC readers detected.")
                return None
            reader = r[0]
            connection = reader.createConnection()
            connection.connect()
            return connection
        except Exception as e:
            print(f"Error connecting to NFC reader: {e}")
            return None

    def check_nfc_card(self):
        card_uid = self.read_card(self.nfc_reader)
        if card_uid and self.card_uid is None:
            self.card_uid = card_uid
            self.handle_card_state(card_uid)

    def handle_card_state(self, card_uid):
        msg = QMessageBox(self)
        msg.setWindowTitle("Udało się odczytać kartę!")
        msg.setStyleSheet("background-color: green;")

        retries = 3
        text_data = None
        for i in range(retries):
            text_data = read_data_from_all_card_sectors()
            if text_data:
                break
            else:
                time.sleep(0.2)

        if text_data:
            card_text_key = text_data[4:]
            self.user_data = self.get_user_data_by_card_text(card_text_key)
            if self.user_data:
                self.user_data['id'] = card_text_key  # Store card text key as ID for updates
                self.name_label.setText(f"Name: {self.user_data.get('firstName', 'Brak danych')} {self.user_data.get('lastName', 'Brak danych')}\nEmail: {self.user_data.get('email', 'Brak danych')}")
                self.coins_label.setText(f"Coins: {self.user_data.get('coins', 'Brak danych')}")
                self.karnet_1h_label.setText(f"Karnet_1h: {self.user_data.get('Karnet_1h', 'Brak danych')}")
                self.karnet_4h_label.setText(f"Karnet_4h: {self.user_data.get('Karnet_4h', 'Brak danych')}")
                self.karnet_8h_label.setText(f"Karnet_8h: {self.user_data.get('Karnet_8h', 'Brak danych')}")
                self.karnet_open_label.setText(f"Karnet_Open: {self.user_data.get('Karnet_Open', 'Brak danych')}")
            else:
                msg.setText("Brak osoby o podanym tekście z karty")
        else:
            msg.setText("Failed to read text data from the card.")
        msg.exec_()
        self.reset_card_uid()

    def reset_card_uid(self):
        self.card_uid = None

    def read_card(self, connection):
        if not connection:
            connection = self.connect_reader()
        try:
            command = [0xFF, 0xCA, 0x00, 0x00, 0x00]
            data, sw1, sw2 = connection.transmit(command)
            if sw1 == 0x90 and sw2 == 0x00:
                uid = toHexString(data)
                return uid
            else:
                print(f"Failed to read card: SW1={sw1:02X}, SW2={sw2:02X}")
                return None
        except Exception as e:
            print(f"Error reading card: {e}")
            return None

    def get_user_data_by_card_text(self, card_text):
        try:
            doc_ref = db.collection('users').document(card_text)
            doc = doc_ref.get()
            if doc.exists:
                user_data = doc.to_dict()
                return user_data
            else:
                return None
        except Exception as e:
            print(f"Error getting document: {e}")
            return None

    def update_field(self, field, increment):
        try:
            if self.user_data:
                user_doc_ref = db.collection('users').document(self.user_data['id'])
                new_value = self.user_data.get(field, 0) + increment
                if new_value < 0:
                    new_value = 0
                user_doc_ref.update({field: new_value})
                self.user_data[field] = new_value  # Update local user data

                # Log update
                print(f"Updated {field} to {new_value}")

                # Update the UI
                if field == 'coins':
                    self.coins_label.setText(f"Coins: {new_value}")
                elif field == 'Karnet_1h':
                    self.karnet_1h_label.setText(f"Karnet_1h: {new_value}")
                elif field == 'Karnet_4h':
                    self.karnet_4h_label.setText(f"Karnet_4h: {new_value}")
                elif field == 'Karnet_8h':
                    self.karnet_8h_label.setText(f"Karnet_8h: {new_value}")
                elif field == 'Karnet_Open':
                    self.karnet_open_label.setText(f"Karnet_Open: {new_value}")
        except Exception as e:
            print(f"Error updating field {field}: {e}")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
