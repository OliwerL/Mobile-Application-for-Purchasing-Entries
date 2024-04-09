from zapisz import *
from czytanie import *

if __name__ == "__main__":
    # Inicjalizacja aplikacji Firebase
    cred = credentials.Certificate("database\serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
    })

    # dodaj_nowy_wezel()
    #zapisz_do_bazy_danych()

    nowa_osoba = {
        "imie": "Sylwek",
        "nazwisko": "Parzych",
        "email": "sebastian.banino@wp.pl",
        "uid": "12 AB 34 CD",
        "wejsciowki": "Wejsciowka noob",
        "termin_waznosci": "09.04.2024"
    }

    # Wywołanie funkcji dodaj_osobe_do_bazy_danych z danymi nowej osoby
    dodaj_osobe_do_bazy_danych(nowa_osoba)


    result = wypisz_osobe_o_danym_uid("12 AB 34 CD")
    if result is None:
        print("Brak osoby o podanym UID")
    else:
        imie,nazwisko,wejsciowki,termin_waznosci=result
        print(f"Imię: {imie}, Nazwisko: {nazwisko}, wejsciowki: {wejsciowki},termin waznosci: {termin_waznosci}")
