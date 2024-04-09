import firebase_admin
from firebase_admin import credentials, db

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
            print(value.get("uid"))
            print(uid)
            print(f"\n")
            if value.get("uid") == uid:
                imie = value.get("imie")
                nazwisko = value.get("nazwisko")
                wejsciowki=value.get("wejsciowki")
                termin_waznosci=value.get("termin_waznosci")
                return imie, nazwisko, wejsciowki,termin_waznosci

    else:
        return None, None,None,None
