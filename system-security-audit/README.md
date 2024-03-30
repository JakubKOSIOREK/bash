# SYSTEM SECURITY AUDIT

## Instalacja

1. Należy skopiować katalog ``system-security-audit`` wraz z jego zawartością do katalogu domowego użytkownika posiadającego uprawnienia sudo.

2. Należy sprawdzić pliki ``tests.sh`` i ``repair.sh`` czy posiadają prawa do wykonywania ('x'). Jeżeli nie to należy im je nadać komedą:

   ```bash
   sudo chmod +x tests.sh
   
   sudo chmod +x repair.sh
   ```

3. Należy sprawdzić, czy pliki testów .sh w folderach ``cis_deb_11_sec_audit_tests`` i ``cis_deb_11_sec_repair_tools`` mają prawa do wykonania ('x'). Jeżeli nie to należy im je nadać komendą:

   ```bash
   sudo find ./cis_deb_11_sec_audit_tests -type f -name "*.sh" -exec chmod +x {} +

   sudo find ./cis_deb_11_sec_repair_tools -type f -name "*.sh" -exec chmod +x {} +
   ```

## Uruchomienie

Urzytkownik sudo nie wymagający hasła `ALL=(ALL) NOPASSWD: ALL`

W celu uruchomienia audytu należy uruchomić skrypt startowy ``tests.sh``

```bash
sudo ./tests.sh
```

> **&#x2139; INFO:**
 Ta komenda uruchamia audyt i wyświetla wyniki testów na konsoli.

Po więcej informacji dotyczących audytu należy użyć komendy:

```bash
sudo ./tests.sh -h
# lub
sudo ./tests.sh --help
```

## Dodatkowe informacje

Jeżeli kopiujemy pliki z Windows możliwe, że będzie trzeba wykonać dodatkową operację na skryptach testowych .sh polegającą na usunięciu znaków końca linii w stylu Windows (\r\n)

```bash
sed -i 's/\r$//' ./tests.sh

# i

for file in ./cis_deb_11_sec_audit_tests/*.sh; do
  sed -i 's/\r$//' "$file"
done
```

## Konfiguracja ustawień systemu w przypadku gdy test zwróci `FAIL`

W katalogu ``cis_deb_11_sec_repair_tools`` znajdują się skrypty mające za zadanie zaimplementowanie zmian zgodnych z wytycznymi. Jeden skrypt naprawczy odpowiada jednemu testowi. Aby uruchomić naprawę należy użyć komendy:

```bash
sudo ./repair.sh [numer_testu]
```

Przykład:

Test zwrócił wynik: `TC_4-1-3-17_SEC-AUDIT-CHACL-COMMAND-USE-RECORDED-001.sh >>> FAIL >>> Brak oczekiwanej reguły audytu dla polecenia chacl.`

Aby dodać brakujące regyły należy użyć komendy:

```bash
sudo ./repair.sh 4-1-3-17
```

co spowoduje wykonanie skryptu naprawczego `RT_4-1-3-17_SEC-AUDIT-CHACL-COMMAND-USE-RECORDED-001.sh`

> **&#x2139; INFO:**
 Można podać kilka numerów testów w jednej lini oddzielonych od siebie spacją
 ```bash
 sudo ./repair.sh 4-1-3-17 4-1-3-18 ...
 ```

> **&#x26A0;; UWAGA:**\
 Przed wykonaniem skryptu naprawczego ``RT_4-1-3-20_SEC-AUDIT-CONFIG-IMMUTABLE-001.sh`` należy się upewnić, że wszystkie reguły audytu są zaimplementowane !

> **&#x26A0;; UWAGA:**\
 Po wykonaniu wszystkich napraw należy wykonać restart systemu i ponowny audyt z opcją zapisu do pliku `.csv`
> ```bash
> sudo ./tests.sh -r
> ```





