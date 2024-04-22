import firebase_admin
from firebase_admin import credentials, db
import sys, os
from kivy.resources import resource_add_path
#czytanie danych z bazy danych

def odczytaj_z_bazy_danych():
    # Ustawienie referencji do węzła w bazie danych
    ref = db.reference('/uzytkownicy')

    # Odczyt danych z bazy danych
    data = ref.get()

    # Sprawdzenie, czy są jakieś dane
    if data:
        print("Dane z bazy danych:")
        for key, value in data.items():
            print(f"Klucz: {key}")
            print("Wartość:")
            for k, v in value.items():
                print(f"  {k}: {v}")
            print()  # Pusta linia oddzielająca kolejne dane
    else:
        print("Brak danych w bazie danych")


def usun_osobe(klucz):
    # Ustawienie referencji do konkretnego klucza w bazie danych
    ref = db.reference('/uzytkownicy/' + klucz)
    # Usunięcie konkretnego klucza
    ref.delete()


def wypisz_osobe_o_danym_uid(uid):
    # Ustawienie referencji do węzła w bazie danych
    ref = db.reference('/uzytkownicy')

    # Pobranie wszystkich danych z bazy danych
    data = ref.get()

    if data:
        for key, value in data.items():
            if value.get("uid") == uid:
                imie = value.get("imie")
                nazwisko = value.get("nazwisko")
                wejsciowki=value.get("wejsciowki")
                termin_waznosci=value.get("termin_waznosci")
                return imie, nazwisko, wejsciowki,termin_waznosci
        return None, None,None,None

    else:
        return None, None,None,None



if __name__ == '__main__':
    if hasattr(sys, '_MEIPASS'):
        resource_add_path((os.path.join(sys._MEIPASS)))

    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
    })
    odczytaj_z_bazy_danych()