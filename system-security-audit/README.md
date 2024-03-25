# SYSTEM SECURITY AUDIT

## Instalacja

1. Należy skopiować katalog ``system-security-audit`` wraz z jego zawartością do katalogu domowego użytkownika posiadającego uprawnienia sudo.

2. Należy sprawdzić plik ``run_tests.sh`` czy posiada prawa do wykonywania ('x'). Jeżeli nie to należy mu je nadać komedą:

   ```bash
   sudo chmod +x run_tests.sh
   ```

3. Należy sprawdzić, czy pliki testów .sh w folderze ``cis_deb_11_sec_audit_tests`` mają prawa do wykonania ('x'). Jeżeli nie to należy im je nadać komendą:

   ```bash
   sudo find ./cis_deb_11_sec_audit_tests -type f -name "*.sh" -exec chmod +x {} +
   ```

## Uruchomienie

Urzytkownik sudo nie wymagający hasła (ALL=(ALL) NOPASSWD: ALL)

W celu uruchomienia audytu należy uruchomić skrypt startowy ``run_tests.sh``

```bash
sudo ./run_tests.sh
```

> **&#x2139; INFO:**
 Ta komenda uruchamia audyt i wyświetla wyniki testów na konsoli.

Po więcej informacji dotyczących audytu należy użyć komendy:

```bash
sudo ./run_tests.sh -h
# lub
sudo ./run_tests.sh --help
```
