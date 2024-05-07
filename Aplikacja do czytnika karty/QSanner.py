import subprocess
from PIL import Image
from pyzbar.pyzbar import decode
import cv2

class QRScanner:
    def __init__(self):
        self.scanned_data = None

    def scan_qr_code(self):
        # Uruchomienie aplikacji domyślnej do skanowania kodów QR na telefonie Android
        try:
            subprocess.run(["adb", "shell", "am", "start", "-a", "android.intent.action.MAIN", "-c", "android.intent.category.APP_CAMERA"])

            # Pobierz obraz z kamery
            cap = cv2.VideoCapture(0)
            ret, frame = cap.read()

            # Zapisz obraz do pliku
            cv2.imwrite('qr_code_image.png', frame)
            cap.release()

        except Exception as e:
            print("Błąd:", e)
            print("To nie działa na Windows 11")

        # Tutaj odczytaj obraz z kamery i skanuj kod QR
        # Używamy pyzbar do skanowania kodów QR
        image = Image.open('qr_code_image.png')
        decoded_objects = decode(image)
        if decoded_objects:
            self.scanned_data = decoded_objects[0].data.decode('utf-8')
        else:
            print("Nie znaleziono kodu QR.")

    def get_scanned_data(self):
        return self.scanned_data
