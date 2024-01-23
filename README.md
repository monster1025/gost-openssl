## Проблема
При конвертации сертификата СБИСа стандартными средствами openssl получаем вот такую ошибку:  
  
```
139657983938816:error:06074079:digital envelope routines:EVP_PBE_CipherInit:unknown pbe algorithm:crypto/evp/evp_pbe.c:95:TYPE=1.2.840.113549.1.12.1.80
139657983938816:error:23077073:PKCS12 routines:PKCS12_pbe_crypt:pkcs12 algor cipherinit error:crypto/pkcs12/p12_decr.c:41:
139657983938816:error:2306A075:PKCS12 routines:PKCS12_item_decrypt_d2i:pkcs12 pbe crypt error:crypto/pkcs12/p12_decr.c:94:
```

## Конвертирование сертификатов от СБИС в формат пригодный для других систем.
  
Для конвертации нужно установить сертификат в систему и убедиться что им можно подписать документы через любой подписывающий сайт.  
  
После этого утилитой P12FromGostCSP.exe нужно экспортировать сертификат в pfx контейнер.  
  
Этот pfx подсовывается в докер и из него экспортируется приватный ключ.  
  
```
docker run -it -v `pwd`/cert:/cert gost-openssl_cert

openssl pkcs12 -in p12.pfx -out p12.pem
```

### Собранный образ
https://hub.docker.com/repository/docker/monster1025/gost_cert

### Команды для конвертации сертификата в нужные ключи:
https://habr.com/ru/post/550664/

```
openssl pkcs12 -in auth.p12 -out key.pem -engine gost -nodes -clcerts
openssl pkcs12 -in auth.p12 -clcerts -nokeys -out pub.crt
openssl smime -sign -signer pub.crt -inkey key.pem -engine gost -binary -outform DER -in document.pdf -out document.pdf.sig
```
or 
```
openssl cms -sign -engine gost -inkey key.pem -signer pub.crt -in document.xml -binary -outform DER -out document.xml.sgn
```
or with cades support
```
openssl cms -sign -engine gost -inkey key.pem -cades -signer pub.crt -in document.xml -binary -outform DER -out document.xml.sgn
```
