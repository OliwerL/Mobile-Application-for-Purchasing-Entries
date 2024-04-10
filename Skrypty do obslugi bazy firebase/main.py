from serwer import Serwer

if __name__ == "__main__":
    bazka = Serwer()
    bazka.odczytaj_z_bazy_danych()
    bazka.zapisz_dane_do_jsona()
