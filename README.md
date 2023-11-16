# xiaomi-CPU-freq
Enable minimal CPU frequency on all clusters that disabled by default

Скрипт разрешает использование минимальных частот на всех кластерах CPU, которые по умолчанию не задействованы.<br>
Использование низких частот положительно влияет на расход батареи.

**Требование**<br>
Наличие root-прав на смартфоне (Magisk)

**Инструкция**<br>
Скопировать скрипт mi11_300MHz.sh в папку /data/adb/service.d<br>
Установить права 0766 (rwxrw-rw-)<br>
Перезагрузить телефон<br>

После перезагрузки в течении ~10 секунд скрипт исполниться.<br>
Результат работы (время использования частоты см. ниже) можно наблюдать в файле /data/local/tmp/300MHz_10s.txt<br>

_*Так же, при необходимости, можно ограничить верхнюю частоту, если вы считаете, что вам не нужен такой мощный смартфон :)<br>
Скрипт подойдет для любых смартфонов Xiaomi (только нужно правильно определить на каких частотах работает ваш CPU и исправить значения в самом скрипте)_

**Частоты без скрипта**<br>
300000   0<br>
403200   0<br>
499200   0<br>
595200   0<br>
691200   65970<br>
806400   961<br>
902400   466<br>
998400   350<br>
1094400  4165<br>
1209600  1108<br>
1305600  2111<br>
1401600  438<br>
1497600  505<br>
1612800  4422<br>
1708800  578<br>
1804800  19676<br>

**Частоты с скриптом** (как можно заметить, стали использоваться 300-595MHz):<br>
300000  29370<br>
403200  1111<br>
499200  548<br>
595200  565<br>
691200  578<br>
806400  483<br>
902400  339<br>
998400  264<br>
1094400 1346<br>
1209600 2004<br>
1305600 870<br>
1401600 263<br>
1497600 290<br>
1612800 440<br>
1708800 248<br>
1804800 10604<br>
