from zapisz import *
from czytanie import odczytaj_z_bazy_danych

if __name__ == "__main__":
    # Inicjalizacja aplikacji Firebase
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
    })

    # dodaj_nowy_wezel()
    # zapisz_do_bazy_danych()
    odczytaj_z_bazy_danych()
