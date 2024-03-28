from zapisz import *
from czytanie import *

if __name__ == "__main__":
    # Inicjalizacja aplikacji Firebase
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
    })

    # dodaj_nowy_wezel()
    #zapisz_do_bazy_danych()

    nowa_osoba = {
        "imie": "Jan",
        "nazwisko": "Kowalski",
        "email": "jan.kowalski@example.com",
        "uid": "5E 86 F9 02"
    }

    # Wywołanie funkcji dodaj_osobe_do_bazy_danych z danymi nowej osoby
    #dodaj_osobe_do_bazy_danych(nowa_osoba)


    imie, nazwisko = wypisz_osobe_o_danym_uid("5E 86 F9 02")
    if imie is None:
        print("Brak osoby o podanym UID")
    else:
        print(f"Imię: {imie}, Nazwisko: {nazwisko}")
