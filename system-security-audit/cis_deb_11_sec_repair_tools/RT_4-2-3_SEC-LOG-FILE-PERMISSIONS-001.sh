#!/usr/bin/env bash

echo -e "\n- Rozpoczynanie naprawy - pliki dzienników mają odpowiednie uprawnienia i właściciela"

# Przeszukuje katalog /var/log w poszukiwaniu plików
find /var/log -type f | while read -r fname; do
  bname="$(basename "$fname")"
  
  # Sprawdza nazwę pliku i stosuje odpowiednie reguły
  case "$bname" in
    lastlog | lastlog.* | wtmp | wtmp.* | btmp | btmp.*)
      # Ustawia uprawnienia, właściciela i grupę dla plików historii logowania
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,2,4,6][0,4]\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod ug-x,o-wx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Pq '^\s*root\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Pq '^\s*(utmp|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
    secure | auth.log)
      # Ustawia uprawnienia, właściciela i grupę dla plików związanych z bezpieczeństwem
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,4]0\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod u-x,g-wx,o-rwx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Pq '^\s*(syslog|root)\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Pq '^\s*(adm|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
    SSSD | sssd)
      # Specjalne zasady dla plików dzienników SSSD
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,2,4,6]0\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod ug-x,o-rwx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Piq '^\s*(SSSD|root)\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Piq '^\s*(SSSD|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
    gdm | gdm3)
      # Ustawienia dla plików dzienników GDM/GDM3
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,2,4,6]0\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod ug-x,o-rwx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Pq '^\s*root\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Pq '^\s*(gdm3?|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
    *.journal)
      # Ustawienia dla plików dzienników systemowych journal
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,4]0\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod u-x,g-wx,o-rwx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Pq '^\s*root\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Pq '^\s*(systemd-journal|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
    *)
      # Domyślne zasady dla innych plików dzienników
      ! stat -Lc "%a" "$fname" | grep -Pq '^\s*[0,2,4,6][0,4]0\s*$' && echo "- zmieniam uprawnienia dla \"$fname\"" && chmod u-x,g-wx,o-rwx "$fname"
      ! stat -Lc "%U" "$fname" | grep -Pq '^\s*(syslog|root)\s*$' && echo "- zmieniam właściciela dla \"$fname\"" && chown root "$fname"
      ! stat -Lc "%G" "$fname" | grep -Pq '^\s*(adm|root)\s*$' && echo "- zmieniam grupę dla \"$fname\"" && chgrp root "$fname"
      ;;
  esac
done

echo -e "- Zakończono naprawę - pliki dzienników mają odpowiednie uprawnienia i właściciela\n"
