from firebase_admin import credentials, db
import firebase_admin
import json

class Serwer():
    cred = credentials.Certificate("serviceAccountKey.json")
    data_od_jsona = None
    plik = 'uzytkownicy.json'

    def __init__(self):
        firebase_admin.initialize_app(self.cred, {
            'databaseURL': 'https://test-bazy-danych-b89e6-default-rtdb.europe-west1.firebasedatabase.app/'
        })
        with open(self.plik, 'r') as file:
            self.data_od_jsona = json.load(file)

    def zapisz_dane_do_jsona(self):
        with open(self.plik, 'w') as json_file:
            json.dump(self.data_od_jsona, json_file, indent=4)

    def odczytaj_z_bazy_danych(self, nazwa_wezla='/uzytkownicy'):
        # Ustawienie referencji do węzła w bazie danych
        ref = db.reference(nazwa_wezla)

        # Odczyt danych z bazy danych
        data = ref.get()

        # Zapis do atrybutu z klasy
        self.data_od_jsona = data

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

    def usun_caly_wezel(self, nazwa_wezla='/uzytkownicy'):
        ref = db.reference(nazwa_wezla)
        ref.delete()

    # Usunięcie części węzła z bazy danych
    def usun_czesc_wezla(self, nazwa_wezla='/uzytkownicy', sciezka_do_czesci=''):
        ref = db.reference(nazwa_wezla)
        ref.child(sciezka_do_czesci).delete()

    # Usunięcie pojedynczego użytkownika
    def usun_uzytkownika_po_username(self, username, nazwa_wezla='/uzytkownicy'):
        ref = db.reference(nazwa_wezla)

        # Wyszukaj użytkownika na podstawie nazwy użytkownika
        query = ref.order_by_child('username').equal_to(username).get()

        if query:
            for key in query:
                ref.child(key).delete()
                print(f'Użytkownik o nazwie użytkownika {username} został usunięty.')
        else:
            print(f'Nie znaleziono użytkownika o nazwie użytkownika {username}.')

    @staticmethod
    def zapisz_do_bazy_danych(nazwa_wezla='/uzytkownicy', plik='uzytkownicy.json'):
        # Odczyt danych z pliku JSON
        with open(plik, 'r') as file:
            data = json.load(file)

        # Ustawienie referencji do węzła w bazie danych
        ref = db.reference(nazwa_wezla)  # Zmieniono ścieżkę do węzła

        # Zapis danych do bazy danych
        ref.update(data)  # Użyj metody update, aby utworzyć lub zaktualizować węzeł

    @staticmethod
    def dodaj_nowy_wezel(nazwa_wezla='/uzytkownicy', plik='uzytkownicy.json'):
        # Odczyt danych z pliku JSON
        with open(plik, 'r') as file:
            data = json.load(file)

        # Ustawienie referencji do nowego węzła w bazie danych
        ref = db.reference(nazwa_wezla)

        # Dodanie danych do nowego węzła z automatycznym generowaniem unikalnego klucza
        ref.push(data)

    # Dodawanie użytkownika po nazwie użytkownika
    @staticmethod
    def dodaj_uzytkownika(nazwa_wezla, plik):
        # Wczytanie danych użytkowników z pliku JSON
        with open(plik, 'r') as file:
            data = json.load(file)

        # Iteracja przez każdego użytkownika w pliku JSON
        for user_id, user_data in data.items():
            username = user_data.get('username')  # Pobranie nazwy użytkownika
            if username:
                ref = db.reference(nazwa_wezla)  # Ustawienie referencji do węzła w bazie danych
                user_ref = ref.child(user_id)  # Ustawienie referencji do węzła użytkownika
                user_ref.set(user_data)  # Dodanie danych użytkownika do bazy danych

    # Dodawanie użytkownika po nazwie użytkownika
    @staticmethod
    def dodaj_uzytkownika_po_username(username, nazwa_wezla='/uzytkownicy', plik='uzytkownicy.json'):
        # Wczytanie danych użytkowników z pliku JSON
        with open(plik, 'r') as file:
            data = json.load(file)

        # Szukanie użytkownika po nazwie użytkownika
        for user_id, user_data in data.items():
            if user_data.get('username') == username:
                ref = db.reference(nazwa_wezla)  # Ustawienie referencji do węzła w bazie danych
                user_ref = ref.child(user_id)  # Ustawienie referencji do węzła użytkownika
                user_ref.set(user_data)  # Dodanie danych użytkownika do bazy danych
                print(f"Użytkownik {username} został dodany do bazy danych.")
                return

        print(f"Nie znaleziono użytkownika o nazwie {username}.")

class Wejscie:
    def __init__(self, uid, email, imie, nazwisko, termin_waznosci, wejsciowki):
        self.uid = uid
        self.email = email
        self.imie = imie
        self.nazwisko = nazwisko
        self.termin_waznosci = termin_waznosci
        self.wejsciowki = wejsciowki

    def __str__(self):
        return f"UID: {self.uid}\nEmail: {self.email}\nImię: {self.imie}\nNazwisko: {self.nazwisko}\nTermin ważności: {self.termin_waznosci}\nWejściówki: {self.wejsciowki}"

    def to_dict(self):
        return {
            "uid": self.uid,
            "email": self.email,
            "imie": self.imie,
            "nazwisko": self.nazwisko,
            "termin_waznosci": self.termin_waznosci,
            "wejsciowki": self.wejsciowki
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            data["uid"],
            data["email"],
            data["imie"],
            data["nazwisko"],
            data["termin_waznosci"],
            data["wejsciowki"]
        )
