from kivy.uix.screenmanager import ScreenManager
from kivymd.uix.button import MDRaisedButton
from kivymd.uix.textfield import MDTextField
from QSanner import QRScanner
from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivymd.app import MDApp

class MainScreen(Screen):
    def __init__(self, **kwargs):
        super(MainScreen, self).__init__(**kwargs)

        # Tworzymy pasek narzędziowy
        toolbar = BoxLayout(orientation='horizontal', size_hint_y=None, height=50)
        title_label = Label(text='Skaner kodów QR', font_size=20)
        toolbar.add_widget(title_label)
        self.add_widget(toolbar)

        # Dodajemy resztę interfejsu
        layout = BoxLayout(orientation='vertical', padding=20)
        self.scanned_data_field = MDTextField(hint_text="Zeskanowane dane", readonly=True, multiline=True)
        layout.add_widget(self.scanned_data_field)
        scan_button = MDRaisedButton(text="Skanuj kod QR", on_press=self.scan_qr_code)
        layout.add_widget(scan_button)
        self.add_widget(layout)

    def scan_qr_code(self, instance):
        scanner = QRScanner()
        scanner.scan_qr_code()
        scanned_data = scanner.get_scanned_data()
        self.scanned_data_field.text = scanned_data if scanned_data else "Nie znaleziono kodu QR."

class QRApp(MDApp):
    def build(self):
        self.screen_manager = ScreenManager()
        self.main_screen = MainScreen(name='main_screen')
        self.screen_manager.add_widget(self.main_screen)
        return self.screen_manager

if __name__ == "__main__":
    QRApp().run()
