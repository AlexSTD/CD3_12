#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьВерсиюИСписокСвойств();
	КонвертацияДанныхXDTOВызовСервера.ЗаполнитьСписокОбъектовФормата(СписокОбъектовФормата, Неопределено, Истина,, ВерсияФормата);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КонвертацияДанныхXDTOКлиент.ЗаполнитьСписокВыбораЭлементаФормы(Элементы.ОбъектФормата, СписокОбъектовФормата);
	КонвертацияДанныхXDTOКлиент.ЗаполнитьСписокВыбораЭлементаФормы(Элементы.СвойствоФормата, СписокСвойств);
	РежимВводаОбъекта = "Выбор из списка";
	РежимВводаСвойства = "Выбор из списка";
	Если ЗначениеЗаполнено(Объект.ОбъектФормата) 
		И СписокОбъектовФормата.НайтиПоЗначению(Объект.ОбъектФормата) = Неопределено Тогда
		РежимВводаОбъекта = "Ручной ввод";
		РучнойВводОбъекта = Истина;
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.СвойствоФормата) 
		И СписокСвойств.НайтиПоЗначению(Объект.СвойствоФормата) = Неопределено Тогда
		РучнойВводСвойства = Истина;
		РежимВводаСвойства = "Ручной ввод";
	КонецЕсли;
	ОбновитьВнешнийВидФормы();
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ОбъектФорматаПриИзменении(Элемент)
	ЗаполнитьСписокСвойств();
	Если ЗначениеЗаполнено(Объект.СвойствоФормата) И СписокСвойств.НайтиПоЗначению(Объект.СвойствоФормата) = Неопределено Тогда
		Объект.СвойствоФормата = "";
	КонецЕсли;
	КонвертацияДанныхXDTOКлиент.ЗаполнитьСписокВыбораЭлементаФормы(Элементы.СвойствоФормата, СписокСвойств);
КонецПроцедуры
&НаКлиенте
Процедура ОбъектФорматаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормыВыбора = Новый Структура("ВерсияФормата, ТекущаяСтрока, РежимРаботы", 
					ВерсияФормата, Объект.ОбъектФормата, "ОбъектФормата");
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектаИлиСвойства",ПараметрыФормыВыбора,Элемент,,,,
			Новый ОписаниеОповещения("ВыбранОбъектФормата", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
		
&НаКлиенте
Процедура СвойствоФорматаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормыВыбора = Новый Структура("ВерсияФормата, ОбъектФормата, ТекущаяСтрока", 
					ВерсияФормата, Объект.ОбъектФормата, Объект.СвойствоФормата);
	ПараметрыФормыВыбора.Вставить("РежимРаботы", "СвойствоФормата");
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектаИлиСвойства",ПараметрыФормыВыбора,Элемент,,,,
			Новый ОписаниеОповещения("ВыбраноСвойствоФормата", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеПриИзменении(Элемент)
	ЗаполнитьВерсиюИСписокСвойств();
	КонвертацияДанныхXDTOКлиент.ЗаполнитьСписокВыбораЭлементаФормы(Элементы.СвойствоФормата, СписокСвойств);
КонецПроцедуры
&НаКлиенте
Процедура РежимВводаОбъектаПриИзменении(Элемент)
	РучнойВводОбъекта = (РежимВводаОбъекта = "Ручной ввод");
	ОбновитьВнешнийВидФормы();
КонецПроцедуры

&НаКлиенте
Процедура РежимВводаСвойстваПриИзменении(Элемент)
	РучнойВводСвойства = (РежимВводаСвойства = "Ручной ввод");
	ОбновитьВнешнийВидФормы();
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьСписокСвойств()
	КонвертацияДанныхXDTOВызовСервера.ЗаполнитьСписокСвойствФормата(СписокСвойств, Неопределено, Объект.ОбъектФормата, ВерсияФормата);
КонецПроцедуры

&НаКлиенте
Процедура ВыбранОбъектФормата(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	Объект.ОбъектФормата = РезультатЗакрытия;
	ОбъектФорматаПриИзменении(Элементы.ОбъектФормата);
КонецПроцедуры

&НаКлиенте
Процедура ВыбраноСвойствоФормата(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	Объект.СвойствоФормата = РезультатЗакрытия;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВнешнийВидФормы()
	ТекСтраницаОбъектФормата = ?(РучнойВводОбъекта, Элементы.СтраницаОбъектФорматаВвод, 
								Элементы.СтраницаОбъектФорматаВыбор);
	Элементы.СтраницыОбъектФормата.ТекущаяСтраница = ТекСтраницаОбъектФормата;
	
	ТекСтраницаСвойствоФормата = ?(РучнойВводСвойства, Элементы.СтраницаСвойствоФорматаВвод, 
								Элементы.СтраницаСвойствоФорматаВыбор);
	Элементы.СтраницыСвойствоФормата.ТекущаяСтраница = ТекСтраницаСвойствоФормата;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВерсиюИСписокСвойств()
	Если Объект.Операция = Перечисления.ОперацииСОбъектамиСвойствамиФормата.Удален Тогда
		ТекВерсия = ПолучитьПредыдущуюВерсиюФормата();
	Иначе
		ТекВерсия = Объект.Владелец.ВерсияФормата;
	КонецЕсли;
	Если ТекВерсия <> ВерсияФормата Тогда
		ВерсияФормата = ТекВерсия;
		ЗаполнитьСписокСвойств();
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПолучитьПредыдущуюВерсиюФормата()
	ТекВерсияФорматаЧислом = ВерсияФорматаЧислом(Объект.Владелец.ВерсияФормата);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ 
	|	Наименование,
	|	Ссылка
	|ИЗ Справочник.ВерсииФормата
	|ГДЕ НЕ ПометкаУдаления И Ссылка <> &ЭтаВерсия
	|УПОРЯДОЧИТЬ ПО Наименование УБЫВ";
	Запрос.УстановитьПараметр("ЭтаВерсия", Объект.Владелец.ВерсияФормата);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ВерсияФорматаЧислом(Выборка.Наименование) < ТекВерсияФорматаЧислом Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЦикла;
	Возврат Справочники.ВерсииФормата.ПустаяСсылка();
КонецФункции

&НаСервере
Функция ВерсияФорматаЧислом(СтрокаВерсии)
	Если Не ЗначениеЗаполнено(СтрокаВерсии) Или СтрокаВерсии = "1.0.beta" Тогда
		Возврат 0;
	КонецЕсли;
	
	ВерсияФорматаЧислом = 0;
	
	РазрядыВерсии = СтрРазделить(СтрокаВерсии, ".");
	Если РазрядыВерсии.Количество() <> 2 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неправильный формат параметра СтрокаВерсии1: %1'"), СтрокаВерсии);
	КонецЕсли;
	
	МножительРазряда = 10000;
	Для ИндексРазрядаОбратный = 0 По 1 Цикл
		ВерсияФорматаЧислом = ВерсияФорматаЧислом + Число(РазрядыВерсии[ИндексРазрядаОбратный])*МножительРазряда;
		МножительРазряда = МножительРазряда / 100;
	КонецЦикла;
	Возврат ВерсияФорматаЧислом;
КонецФункции




#КонецОбласти
