# trigger

Задание 
Для базы данных создать Журнал операций – База данных, содержащая журнал. База Журнал операций содержит следующие таблицы:
Таблица Журнал операций, хранящая список операций пользователей базы данных
Таблица содержит следующие столбцы:
- имя пользователя;
- операция (insert, update, delete);
- дата и время операции;
- таблица, над которой выполнена операция

журнальные копии таблиц исходной базы данных, которые хранят все изменения, производимые над таблицей. Структура журнальной копии повторяет структуру исходной таблицы + поле-ссылка на таблицу Журнал операций

Для каждой таблицы исходной базы данных создать триггеры: добавления, удаления и изменения. Эти триггеры должны добавлять данные в соответствующие таблицы Журнала операций.

