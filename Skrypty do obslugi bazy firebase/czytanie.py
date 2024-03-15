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

if __name__ == "__main__":
    odczytaj_z_bazy_danych()
