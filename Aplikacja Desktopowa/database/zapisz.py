import firebase_admin
from firebase_admin import credentials, db
import json

# zapis do bazy danych

def zapisz_do_bazy_danych():

    # Odczyt danych z pliku JSON
    with open('uzytkownicy.json', 'r') as file:
        data = json.load(file)

    # Ustawienie referencji do węzła w bazie danych
    ref = db.reference('/uzytkownicy')  # Zmieniono ścieżkę do węzła

    # Zapis danych do bazy danych
    ref.update(data)  # Użyj metody update, aby utworzyć lub zaktualizować węzeł

def dodaj_nowy_wezel():

    # Odczyt danych z pliku JSON
    with open('uzytkownicy.json', 'r') as file:
        data = json.load(file)

    # Ustawienie referencji do nowego węzła w bazie danych
    ref = db.reference('/uzytkownicy')

    # Dodanie danych do nowego węzła z automatycznym generowaniem unikalnego klucza
    ref.push(data)

def dodaj_osobe_do_bazy_danych(nowa_osoba):
    # Ustawienie referencji do węzła w bazie danych
    ref = db.reference('/uzytkownicy')

    # Dodanie danych nowej osoby do nowego węzła z automatycznym generowaniem unikalnego klucza
    ref.push(nowa_osoba)