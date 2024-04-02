# SYSTEM SECURITY AUDIT

## Instalacja

1. Należy skopiować katalog ``system-security-audit`` wraz z jego zawartością do katalogu domowego użytkownika posiadającego uprawnienia sudo.

2. Należy sprawdzić pliki ``tests.sh`` i ``repair.sh`` czy posiadają prawa do wykonywania ('x'). Jeżeli nie to należy im je nadać komedą:

   ```bash
   sudo chmod +x audit_deb_11.sh
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
sudo ./audit_deb_11.sh
```

> **&#x2139; INFO:**
 Ta komenda uruchamia audyt i wyświetla wyniki testów na konsoli.

Po więcej informacji dotyczących audytu należy użyć komendy:

```bash
sudo ./audit_deb_11.sh -h
# lub
sudo ./audit_deb_11.sh --help
```

## Dodatkowe informacje

Jeżeli kopiujemy pliki z Windows możliwe, że będzie trzeba wykonać dodatkową operację na skryptach testowych .sh polegającą na usunięciu znaków końca linii w stylu Windows (\r\n)

```bash
sed -i 's/\r$//' ./audit_deb_11.sh

# i

for file in ./cis_deb_11_sec_audit_tests/*.sh; do
  sed -i 's/\r$//' "$file"
done
```

## Konfiguracja ustawień systemu w przypadku gdy test zwróci `FAIL`

W katalogu ``cis_deb_11_sec_repair_tools`` znajdują się skrypty mające za zadanie zaimplementowanie zmian zgodnych z wytycznymi.


> **&#x26A0; UWAGA:**\
 Przed wykonaniem skryptu naprawczego ``02_repair_audit_deb_11.sh`` należy się upewnić, że wszystkie reguły audytu są zaimplementowane !


> **&#x26A0; UWAGA:**\
 Po wykonaniu wszystkich napraw należy wykonać restart systemu i ponowny audyt z opcją zapisu do pliku `.csv`
> ```bash
> sudo ./audit_deb_11.sh -r
> ```

