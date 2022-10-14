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
openssl pkcs12 -in p12.pfx -out p12.pem
```




git@github.com:monster1025/gost-openssl.git