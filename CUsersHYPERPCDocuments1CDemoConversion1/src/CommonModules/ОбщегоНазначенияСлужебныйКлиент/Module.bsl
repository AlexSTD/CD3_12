////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры и функции общего назначения
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//	Контекст - Структура - контекст процедуры:
//		* Оповещение           - ОписаниеОповещения - .
//		* Идентификатор        - Строка             - .
//		* Местоположение       - Строка             - .
//		* Кэшировать           - Булево             - .
//		* ПредложитьУстановить - Булево             - .
//		* ТекстПояснения       - Строка             - .
//
Процедура ПодключитьКомпоненту(Контекст) Экспорт
	
	Если Не МестоположениеКомпонентыКорректно(Контекст.Местоположение) Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректное значение параметра Местоположение (%1) 
			     |в ОбщегоНазначенияСлужебныйКлиент.ПодключитьКомпоненту'"), Контекст.Местоположение);
	КонецЕсли;
	
	Если Контекст.Кэшировать Тогда 
		
		// Получение из кэша экземпляра внешней компоненты.
		
		ПодключаемыйМодуль = Неопределено;
		КэшированныеКомпоненты = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.КэшированныеКомпоненты"];
		
		Если ТипЗнч(КэшированныеКомпоненты) = Тип("ФиксированноеСоответствие") Тогда
			ПодключаемыйМодуль = КэшированныеКомпоненты.Получить(Контекст.Местоположение);
		КонецЕсли;
		
		Если ПодключаемыйМодуль <> Неопределено Тогда 
			
			Результат = Новый Структура;
			Результат.Вставить("Подключено", Истина);
			Результат.Вставить("ПодключаемыйМодуль", ПодключаемыйМодуль);
			ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
			
	СимволическоеИмя = "С" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""); //генерация уникального имени
	Контекст.Вставить("СимволическоеИмя", СимволическоеИмя);
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодключитьКомпонентуЗавершение", ЭтотОбъект, Контекст,
		"ПодключитьКомпонентуЗавершениеПоОшибке", ЭтотОбъект);
			
	НачатьПодключениеВнешнейКомпоненты(Оповещение, Контекст.Местоположение, СимволическоеИмя);

КонецПроцедуры

// Параметры:
//	Контекст - Структура - контекст процедуры:
//		* Оповещение     - ОписаниеОповещения - .
//		* Местоположение - Строка             - .
//		* ТекстПояснения - Строка             - .
//
Процедура УстановитьКомпоненту(Контекст) Экспорт
	
	Если Не МестоположениеКомпонентыКорректно(Контекст.Местоположение) Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректное значение параметра Местоположение (%1) 
			     |в ОбщегоНазначенияСлужебныйКлиент.УстановитьКомпоненту'"), Контекст.Местоположение);
	КонецЕсли;
	
#Если ВебКлиент Тогда
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКомпонентуПослеОтветаНаВопросОбУстановке", ЭтотОбъект, Контекст);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
	
	ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеВнешнейКомпоненты", 
		ПараметрыФормы,,,,, Оповещение);

#Иначе 
	
	УстановитьКомпонентуНачатьУстановку(Контекст);
		
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	// В веб клиенте под MacOS расширение не доступно.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоMacКлиент = (СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64);
	Если ЭтоMacКлиент Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами";
	ПервоеОбращениеЗаСеанс = ПараметрыПриложения[ИмяПараметра] = Неопределено;
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами());
	КонецЕсли;
	ПредлагатьУстановкуРасширенияРаботыСФайлами	= ПараметрыПриложения[ИмяПараметра] Или ПервоеОбращениеЗаСеанс;
	
	Если ДополнительныеПараметры.ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстПредложения", ДополнительныеПараметры.ТекстПредложения);
	ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", ДополнительныеПараметры.ВозможноПродолжениеБезУстановки);
	ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы,,,,,ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
	
КонецПроцедуры

Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение(Действие, ОповещениеОЗакрытии) Экспорт
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать"
		Или Действие = "РасширениеПодключено" Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Ложь);
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

Процедура ПроверитьРасширениеРаботыСФайламиПодключеноЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗакрытии);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ДополнительныеПараметры.ТекстПредупреждения;
	Если ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не установлено расширение для веб-клиента 1С:Предприятие.'")
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтрРазделить(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;	
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ЗарегистрироватьCOMСоединительЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;

КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеФормыЗавершение", ЭтотОбъект, Параметры);
	Если ПустаяСтрока(Параметры.ТекстПредупреждения) Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
	Иначе
		ТекстВопроса = Параметры.ТекстПредупреждения;
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, ,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормыЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеСохранитьИЗакрыть);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Иначе
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	РежимВопроса = РежимДиалогаВопрос.ДаНет;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение", ЭтотОбъект, Параметры);
	
	ПоказатьВопрос(Оповещение, Параметры.ТекстПредупреждения, РежимВопроса);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение(Ответ, Параметры) Экспорт
	
	Форма = Параметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да
		Или Ответ = КодВозвратаДиалога.ОК Тогда
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Истина;
		Если Параметры.ОписаниеОповещенияЗакрыть <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияЗакрыть);
		КонецЕсли;
		Форма.Закрыть();
	Иначе
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяОбъектаМетаданных(Тип) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ИменаОбъектовМетаданных";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Соответствие);
	КонецЕсли;
	ИменаОбъектовМетаданных = ПараметрыПриложения[ИмяПараметра];
	
	Результат = ИменаОбъектовМетаданных[Тип];
	Если Результат = Неопределено Тогда
		Результат = СтандартныеПодсистемыВызовСервера.ИмяОбъектаМетаданных(Тип);
		ИменаОбъектовМетаданных.Вставить(Тип, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция МестоположениеКомпонентыКорректно(Местоположение)
	
	Если СтрНачинаетсяС(Местоположение, "e1cib/") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ШагиПути = СтрРазделить(Местоположение, ".");
	Если ШагиПути.Количество() < 2 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Путь = Новый Структура;
	Попытка
		Для каждого ШагПути Из ШагиПути Цикл 
			Путь.Вставить(ШагПути);
		КонецЦикла;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#Область ПодключениеВнешнейКомпоненты

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуЗавершение(Подключено, Контекст) Экспорт 
	
	ПодключаемыйМодуль = Неопределено;
	
	Результат = Новый Структура;
	Результат.Вставить("Подключено", Подключено);
	
	Если Не Подключено Тогда 
		
		Если Контекст.ПредложитьУстановить Тогда 
		
			ПодключитьКомпонентуНачатьУстановку(Контекст);
			Возврат;
			
		КонецЕсли;
	
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка при подключении внешней компоненты'"));
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
		Возврат;
		
	КонецЕсли;
		
	Попытка
		
		ПодключаемыйМодуль = Новый("AddIn." + Контекст.СимволическоеИмя + "." + Контекст.Идентификатор);
			
		Если ПодключаемыйМодуль = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Ошибка при создании экземпляра внешней компоненты'");	
		КонецЕсли;
		
	Исключение
		Результат.Вставить("Подключено"    , Ложь);
		Результат.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	Если Контекст.Кэшировать Тогда 
		
		// Помещение в кэш экземпляра внешней компоненты.
		
		Соответствие = Новый Соответствие;
		КэшированныеКомпоненты = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.КэшированныеКомпоненты"];
		Если ТипЗнч(КэшированныеКомпоненты) = Тип("ФиксированноеСоответствие") Тогда
			Для Каждого Элемент Из КэшированныеКомпоненты Цикл
				Соответствие.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;
		КонецЕсли;
		
		Соответствие.Вставить(Контекст.Местоположение, ПодключаемыйМодуль);
		
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ВнешниеКомпоненты.КэшированныеКомпоненты",
			Новый ФиксированноеСоответствие(Соответствие));
		
	КонецЕсли;
	
	Результат.Вставить("ПодключаемыйМодуль", ПодключаемыйМодуль);
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуНачатьУстановку(Контекст)
	
	Оповещение = Новый ОписаниеОповещения(
		"ПодключитьКомпонентуПослеУстановки", ЭтотОбъект, Контекст);
	
	КонтекстУстановки = Новый Структура;
	КонтекстУстановки.Вставить("Оповещение"    , Оповещение);
	КонтекстУстановки.Вставить("Местоположение", Контекст.Местоположение);
	КонтекстУстановки.Вставить("ТекстПояснения", Контекст.ТекстПояснения);
	
	УстановитьКомпоненту(КонтекстУстановки);
	
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуПослеУстановки(Результат, Контекст) Экспорт 
	
	Если Не Результат.Установлено Тогда 
		
		РезультатПодключения = Новый Структура;
		РезультатПодключения.Вставить("Подключено"    , Ложь);
		РезультатПодключения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатПодключения);
		Возврат;
		
	КонецЕсли;
	
	Контекст.ПредложитьУстановить = Ложь; // Одна попытка установки уже прошла.
	ПодключитьКомпоненту(Контекст);
		
КонецПроцедуры

// Продолжение процедуры ПодключитьКомпоненту.
Процедура ПодключитьКомпонентуЗавершениеПоОшибке(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("Подключено"    , Ложь);
	Результат.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаВнешнейКомпоненты

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуПослеОтветаНаВопросОбУстановке(Ответ, Контекст) Экспорт
	
	// Результат: 
	// - КодВозвратаДиалога.Да - Установить.
	// - КодВозвратаДиалога.Отмена - Отклонить.
	// - Неопределено - Закрыто окно.
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УстановитьКомпонентуНачатьУстановку(Контекст);
	Иначе
		Результат = Новый Структура;
		Результат.Вставить("Установлено"   , Ложь);
		Результат.Вставить("ОписаниеОшибки", "");
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуНачатьУстановку(Контекст)
	
	Если Не МестоположениеКомпонентыКорректно(Контекст.Местоположение) Тогда 
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректное значение параметра Местоположение (%1) 
			     |в ОбщегоНазначенияСлужебныйКлиент.УстановитьКомпонентуНачатьУстановку'"), Контекст.Местоположение);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКомпонентуЗавершение", ЭтотОбъект, Контекст,
		"УстановитьКомпонентуЗавершениеПоОшибке", ЭтотОбъект);
	
	// Если компонента была ранее подключена, то выдается интерактивное сообщение платформой вместо исключения.
	// Скорее всего ошибка платформы.
	
	НачатьУстановкуВнешнейКомпоненты(Оповещение, Контекст.Местоположение);
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуЗавершение(Контекст) Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("Установлено", Истина);
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры УстановитьКомпоненту.
Процедура УстановитьКомпонентуЗавершениеПоОшибке(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("Установлено"   , Ложь);
	Результат.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти