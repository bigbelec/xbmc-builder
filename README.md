xbmc-builder
============

Build scripts for XBMC and related packages.

forked from AndreyPavlenko/xbmc-builder

 Создаем директории:

 mkdir $HOME/ppa
 
 mkdir $HOME/ppa/sources
 
 клонируем git, нужный для сборки пакетов:
 
 cd $HOME/ppa/sources/
 
 выполняем для клонирования XBMC ветки frodo из github bigbelec :
 
 git clone -b frodo https://github.com/bigbelec/xbmc.git

  Клонируем скрипты для сборки deb пакетов XBMC:

  mkdir -p $HOME/ppa/builders/xbmc-builder
 
 git clone https://github.com/bigbelec/xbmc-builder.git $HOME/ppa/builders/xbmc-builder

Cоздаём в домашней директории конфигурационный файл :

sudo nano  ~/.build.config

В этом файле нужно прописать настройки :

GPGKEY='ключ в РРА' 

DEBEMAIL='имя <e-mail>' указываем данные в РРА 

например такие данные РРА: aap <andrey.a.pavlenko@gmail.com>

PPA_URL='ссылка на рра и ветка куда отправлять собранные source.changes'

например 'https://launchpad.net/~aap/+archive/xbmc-fernetmenta'

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64'

указываем платформы убунт для сборки (i386 по умолчанию)

: ${MAINTAINER:="$DEBEMAIL"}

: ${BUILDPACKAGE_ARGS:="-k$GPGKEY"}

: ${SOURCES_DIR:="$HOME/ppa/sources"}

: ${PPA_BUILDER:="$HOME/ppa/ppa-builder"}

: ${BASETGZ_DIR:='/var/cache/pbuilder/base'}

: ${APT_CACHE_DIR:='/var/cache/pbuilder/aptcache'}

: ${BUILD_DIR:="/tmp/build/$$"}

: ${DEB_MIRROR:='http://ru.archive.ubuntu.com/ubuntu'}

устанавливаем утилиту dput,

создаём dput.cf в домашней директории файл для отправки пакетов в РРА

sudo nano  ~/dput.cf

заполняем :

[frodo] 

fqdn = ppa.launchpad.net 

method = ftp 

incoming = ~bigbax/frodo/ubuntu/ 

login = anonymous 

allow_unsigned_uploads = 0

Делаем предподготовку в своём github:

git clone https://github.com/bigbelec/xbmc.git

cd xbmc

git init

Переключаемся на нужную ветку гита :

git checkout frodo

На запрос :

*** Please tell me who you are.

вводим поочерёдно :

git config --global user.email "логин в github"

git config --global user.name "password" пароль пользователя в самой системе убунту

делаем изменения(патчи) в локальном гите

индексируем:

git add .

делаем коммит:

git commit -a -m 'pvr: fix channel switch for addons using other stream'

отправляем измнения в гит в инете:

git push -u https://github.com/bigbelec/xbmc.git

Username for 'https://github.com': bigbelec2014@yandex.ru

Password for 'https://bigbelec2014@yandex.ru@github.com':  пароль в github

cd /home/login/ppa/sources

git clone -b frodo https://github.com/bigbelec/xbmc.git

cd xbmc

git status

если в ответ frodo, то всё сделано правильно,   и

exit

У себя в github также делаем по дефолту frodo

Меняем в конфигурации ветку для сборки:

sudo nano /home/login/ppa/builders/xbmc-builder/xbmc/build.sh 

: ${PKG_NAME:='xbmc'}

: ${PKG_EPOCH:='2'}

: ${SRC_URL:='https://github.com/bigbelec/xbmc.git'}

: ${REV:='origin/frodo'}

И наконец создаем source.changes для отправки в РРА :

cd /home/login/ppa/builders/xbmc-builder/xbmc

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64' ./build.sh create


cd /home/login/ppa/builders/xbmc-builder/xbmc/distribs/26.10.13/src

dput ppa:bigbax/frodo xbmc_12.2-20398~cf3a9a5-ppa1~precise_source.changes

Создаем патч.

  git diff > ~/ppa/builders/xbmc-builder/xbmc/debian/patches/strings.patch

Прописываем этот патч в debian/patches/series

Делаем и отправляем в РРА аддоны :

cd /home/login/ppa/sources

git clone https://github.com/pipelka/xbmc-addon-xvdr.git

exit

cd /home/login/ppa/builders/xbmc-builder/xbmc-addon-xvdr

TARGET_PLATFORMS='precise:amd64 quantal:amd64 raring:amd64 saucy:amd64' ./build.sh create

exit

cd /home/login/ppa/builders/xbmc-builder/xbmc-addon-xvdr/distribs/26.10.13/src

отправляем в своё РРА :

dput ppa:bigbax/frodo xbmc-addon-xvdr_0.9.8-361~acd4e14-ppa1~precise_source.changes
