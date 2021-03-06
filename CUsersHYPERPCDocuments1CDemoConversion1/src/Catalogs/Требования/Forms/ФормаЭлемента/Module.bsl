#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КонвертацияДанныхXDTOВызовСервера.ЗаполнитьСписокОбъектовФормата(СписокОбъектовФормата, Неопределено, Истина,, Объект.ВерсияФормата);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидОбластиПрименения = ?(ЗначениеЗаполнено(Объект.ГруппировкаОбъектовФормата), 1, 0);
	КонвертацияДанныхXDTOКлиент.ЗаполнитьСписокВыбораЭлементаФормы(Элементы.ОбъектФормата, СписокОбъектовФормата);
	РежимВводаОбъекта = "Выбор из списка";
	Если ЗначениеЗаполнено(Объект.ОбъектФормата) 
		И СписокОбъектовФормата.НайтиПоЗначению(Объект.ОбъектФормата) = Неопределено Тогда
		РежимВводаОбъекта = "Ручной ввод";
		РучнойВводОбъекта = Истина;
	КонецЕсли;
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Очистка неиспользуемых реквизитов.
	Если ВидОбластиПрименения = 0 И ЗначениеЗаполнено(Объект.ГруппировкаОбъектовФормата) Тогда
		Объект.ГруппировкаОбъектовФормата = Неопределено;
	КонецЕсли;
	Если ВидОбластиПрименения = 1 И ЗначениеЗаполнено(Объект.ОбъектФормата) Тогда
		Объект.ОбъектФормата = "";
	КонецЕсли;
	
	ПередЗаписьюНаСервере(Объект.Ссылка);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПередЗаписьюНаСервере(Ссылка)
	
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ПроектныеРешения.Ссылка
	|ИЗ
	|	Справочник.ПроектныеРешения КАК ПроектныеРешения
	|ГДЕ
	|	ПроектныеРешения.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	Если Запрос.Выполнить().Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не введено ни одного проектного решения по данному требованию.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОбластиПримененияПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектФорматаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормыВыбора = Новый Структура("ВерсияФормата, ТекущаяСтрока, РежимРаботы", 
					Объект.ВерсияФормата, Объект.ОбъектФормата, "ОбъектФормата");
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектаИлиСвойства",ПараметрыФормыВыбора,Элемент,,,,
			Новый ОписаниеОповещения("ВыбранОбъектФормата", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура РежимВводаОбъектаПриИзменении(Элемент)
	РучнойВводОбъекта = (РежимВводаОбъекта = "Ручной ввод");
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.ГруппаОбъектФормата.Видимость = ВидОбластиПрименения = 0;
	Элементы.ГруппировкаОбъектовФормата.Видимость = ВидОбластиПрименения = 1;
	Если ВидОбластиПрименения = 0 Тогда
		ТекСтраницаОбъектФормата = ?(РучнойВводОбъекта, Элементы.СтраницаОбъектФорматаВвод, 
									Элементы.СтраницаОбъектФорматаВыбор);
		Элементы.СтраницыОбъектФормата.ТекущаяСтраница = ТекСтраницаОбъектФормата;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранОбъектФормата(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	Объект.ОбъектФормата = РезультатЗакрытия;
КонецПроцедуры

#КонецОбласти