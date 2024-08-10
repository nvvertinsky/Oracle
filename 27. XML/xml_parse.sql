create table orders of xmltype;
insert into orders values ('<PurchaseOrder DateCreated="2011-01-31">
                            <LineItems>
                              <LineItem ItemNumber="1">
                                <Part Description="Octopus">31398750123</Part>
                                <Quantity>3.0</Quantity>
                              </LineItem>
                              <LineItem ItemNumber="5">
                                <Part Description="King Ralph">18713810168</Part>
                                <Quantity>7.0</Quantity>
                              </LineItem>
                            </LineItems>
                            </PurchaseOrder>');
                            
-- Вставка из файла po.xml, который доступен из директории XMLDIR
insert into orders values (xmltype(bfilename('XMLDIR', 'po.xml'), nls_charset_id('AL32UTF8')));

-- Доступ к узлам и атрибутам XML при помощи xmlquery
select xmlquery('/PurchaseOrder/LineItems/LineItem/Quantity' /*xpath выражение*/ passing object_value /*виртуальная колонка табл orders*/ returning content) qty from orders;
select xmlquery('/PurchaseOrder/LineItems/LineItem[2]/@ItemNumber' passing object_value returning content) qty from orders; -- Доступ к атрибуту

-- xmlcast - приводит значение текстового узла или атрибута к скалярному типу. При это xpath выражение, передаваемое в xmlquery, должно возвращать уникальный
-- листовой узел или атрибут
select xmlcast(xmlquery('/PurchaseOrder/LineItems/LineItem/Part/text()' passing object_value returning content) as varchar2(30)) part from orders;
select xmlcast(xmlquery('/PurchaseOrder/LineItems/LineItem[1]/Part/@Description' passing object_value returning content) as varchar2(100)) descr from orders;


-- xmlexists - возвращает true, если такой узел есть, иначе false
select count(1)
  from orders
 where xmlexists('$p//PurchaseOrder/LineItems/LineItem' passing object_value as "p");
 
select xmlcast(xmlquery('/PurchaseOrder/LineItems/LineItem[2]/Quantity' passing object_value returning content) as number) qty
  from orders
 where xmlexists('$p//PurchaseOrder/LineItems/LineItem[2]/Part[@Description="King Ralph"]' passing object_value as "p");

-- Данные для последующих примеров
delete from orders;
insert into orders values ('<PurchaseOrder DateCreated="2011-01-31">
                            <LineItems>
                              <LineItem ItemNumber="1">
                                <Part Description="Octopus">31398750123</Part>
                                <Quantity>9.0</Quantity>
                              </LineItem>
                              <LineItem ItemNumber="5">
                                <Part Description="Laptop">18713810168</Part>
                                <Quantity>7.0</Quantity>
                                <UOM>PCS</UOM>
                                <Price>950</Price>
                              </LineItem>
                            </LineItems>
                            </PurchaseOrder>');

-- xmltable - на основе xpath выражения выбирает фрагмент XML и превращает его в виртуальную таблицу из которой можно выполнять sql запрос. 
select qty.column_value
  from orders ord,
       xmltable('/PurchaseOrder/LineItems/LineItem/Quantity' passing ord.object_value) qty
 where xmlexists('$p//PurchaseOrder/LineItems/LineItem[2]/Part[@Description="Laptop"]' passing ord.object_value as "p");

select qty.*
  from orders ord,
       xmltable('/PurchaseOrder/LineItems' passing ord.object_value
        columns Part varchar(30) path 'LineItem[1]/Part',
                Quantity number(12) path 'LineItem[1]/Quantity') qty
 where xmlexists('$p//PurchaseOrder/LineItems/LineItem[2]/Part[@Description="Laptop"]' passing ord.object_value as "p");
 
-- XPath выражение в функции XMLTable может возвращать как конечный узел так и фрагмент XML типа XMLType
select DateCreated, LineItem, Part, Quantity
  from (select DateCreated, LineItem
          from orders ord,
               xmltable('/PurchaseOrder' passing ord.object_value 
                columns DateCreated varchar(30) path '@DateCreated',
                        LineItem xmltype path 'LineItems/LineItem')) t,
               
               xmltable('/LineItem' passing t.LineItem 
                columns LineNumber number(12) path '@ItemNumber',
                        Part varchar2(30) path 'Part',
                        Quantity number(12) path 'Quantity');
               
-- Данные для последующих примеров
create table my_orders (order_id number, ord xmltype) xmltype column ord store as binary xml;
insert into my_orders (order_id, ord) values (1, '<PurchaseOrder DateCreated="2011-01-31">
                                                    <LineItems>
                                                      <LineItem ItemNumber="1">
                                                        <Part Description="Octopus">31398750123</Part>
                                                        <Quantity>9.0</Quantity>
                                                      </LineItem>
                                                      <LineItem ItemNumber="5">
                                                        <Part Description="Laptop">18713810168</Part>
                                                        <Quantity>7.0</Quantity>
                                                        <UOM>PCS</UOM>
                                                        <Price>950</Price>
                                                        <ShipTo>
                                                          <Country>Russia</Country>
                                                          <City>Moscow</City>
                                                          <Street>Lva Tolstogo</Street>
                                                          <Building>16</Building>
                                                        </ShipTo>
                                                      </LineItem>
                                                    </LineItems>
                                                 </PurchaseOrder>');
                                                 
-- xmltable можно так же использовать в подзапросе в блоке select 

-- Данные для последующих примеров
insert into my_orders (order_id, ord) values (3, '<PurchaseOrder DateCreated="2011-01-31">
                                                    <Customer>
                                                      <FirstName>Johnnie</FirstName>
                                                      <LastName>Walker</LastName>
                                                    </Customer>
                                                    <LineItems>
                                                      <LineItem ItemNumber="1">
                                                        <Part Description="Octopus">31398750123</Part>
                                                        <Quantity>9.0</Quantity>
                                                      </LineItem>
                                                      <LineItem ItemNumber="5">
                                                        <Part Description="Laptop">18713810168</Part>
                                                        <Quantity>7.0</Quantity>
                                                        <UOM>PCS</UOM>
                                                        <Price>950</Price>
                                                        <ShipTo>
                                                          <Country>Russia</Country>
                                                          <City>Moscow</City>
                                                          <Street>Lva Tolstogo</Street>
                                                          <Building>16</Building>
                                                        </ShipTo>
                                                      </LineItem>
                                                    </LineItems>
                                                 </PurchaseOrder>');

-- Обновление XML данных 

-- Функция updateXML используется для обновления данных XML внутри экземпляра XMLType используя XPath выражения.
select xmlcast(xmlquery('/PurchaseOrder/Customer/FirstName/text()' passing orders.ord returning content) as varchar(30)) part
  from my_orders orders
 where xmlexists('$p/PurchaseOrder/Customer/LastName[text()="Walker"]' passing orders.ord as "p");
 
update my_orders orders
   set orders.ord = updatexml(orders.ord, '/PurchaseOrder/Customer/FirstName/text()', 'John')
 where xmlexists('$p/PurchaseOrder/Customer/LastName[text()="Walker"]' passing orders.ord as "p");


-- Можно обновлять целые значения
update my_orders orders
   set orders.ord = updatexml(orders.ord, '/PurchaseOrder/LineItems/LineItem[1]', xmltype('<LineItem ItemNumber="2">
                                                                                             <Part Description="Omar">111245456</Part>
                                                                                             <Quantity>3.0</Quantity>
                                                                                             <UOM>Kg</UOM>
                                                                                             <Price>300</Price>
                                                                                           </LineItem>'))
 where xmlexists('$p/PurchaseOrder/Customer/LastName[text()="Walker"]' passing orders.ord as "p");
 
 

delete from my_orders;
insert into my_orders (order_id, ord) values (1, '<PurchaseOrder DateCreated="2013-09-31">
                                                    <Customer>
                                                      <FirstName>Johnnie</FirstName>
                                                      <LastName>Walker</LastName>
                                                    </Customer>
                                                    <LineItems>
                                                      <LineItem ItemNumber="2">
                                                        <Part Description="Omar">111245456</Part>
                                                        <Quantity>3.0</Quantity>
                                                      </LineItem>
                                                      <LineItem ItemNumber="5">
                                                        <Part Description="Laptop">18713810168</Part>
                                                        <Quantity>7.0</Quantity>
                                                        <UOM>PCS</UOM>
                                                        <Price>950</Price>
                                                        <ShipTo>
                                                          <Country>Russia</Country>
                                                          <City>Moscow</City>
                                                          <Street>Lva Tolstogo</Street>
                                                          <Building>16</Building>
                                                        </ShipTo>
                                                      </LineItem>
                                                    </LineItems>
                                                 </PurchaseOrder>');
-- Правильно обновляем Part Description="Omar"
update my_orders orders
   set orders.ord = updatexml(orders.ord, '/PurchaseOrder/LineItems/LineItem[Part[@Description="Omar"]]/Price/text()', '200')
 where xmlexists('$p/PurchaseOrder/Customer/LastName[text()="Walker"]' passing orders.ord as "p");

--1:16:04
-- insertChildXML - вставляет дочерние элементы (одного типа) под родительским элементом
-- insertChildXMLBefore, insertChildXMLAfter - вставляет элементы коллекции перед или после указанного элемента коллекции внутри родительского элемента

-- insertXMLBefore, insertXMLAfter - вставляет один или несколько узлов любого типа
-- appendChildXML - вставляет один или несколько дочерних элементов в конец для указанного узла


insert into my_orders (order_id, ord) values (4, '<PurchaseOrder DateCreated="2013-07-15">
                                                  <LineItems>
                                                    <LineItem ItemNumber="1">
                                                      <Part Description="Omar">111245456</Part>
                                                      <Quantity>3.0</Quantity>
                                                    </LineItem>
                                                  </LineItems>
                                               </PurchaseOrder>');

update my_orders orders
   set orders.ord = insertchildxml(orders.ord, '/PurchaseOrder/LineItems', 'LineItem', xmltype('<LineItem ItemNumber="1">
                                                                                                  <Description>Rocket Science</Description>
                                                                                                  <Part Description="Rocket Science">12356788</Part>
                                                                                                  <Quantity>1</Quantity>
                                                                                                </LineItem>'))
 where orders.order_id = 4;
   

-- deleteXML - используется для удаления фрагмента XML. При этом исходные данные в БД не затрагиваются, а создается копия документа в которой
-- производится удаление. Результат затем можно использовать для обновления данных таблицы командой update.
select deletexml(orders.ord, '/PurchaseOrder/LineItems/LineItem[1]')
  from my_orders orders
 where xmlexists('$p/PurchaseOrder/LineItems/LineItem/Part[@Description="Rocket Science"]' passing orders.ord as "p");







