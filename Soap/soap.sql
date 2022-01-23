/*
Структура SOAP-сообщения выглядит так:
Envelope — корневой элемент, который определяет сообщение и пространство имен, использованное в документе.
Header — содержит атрибуты сообщения, например: информация о безопасности или о сетевой маршрутизации.
Body — содержит сообщение, которым обмениваются приложения.
Fault — необязательный элемент, который предоставляет информацию об ошибках, которые произошли при обработке сообщений.

Пример SOAP-запроса:
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="[http://www.w3.org/2001/XMLSchema-instance](http://www.w3.org/2001/XMLSchema-instance)" xmlns:xsd="[http://www.w3.org/2001/XMLSchema](http://www.w3.org/2001/XMLSchema)" xmlns:soap="[http://schemas.xmlsoap.org/soap/envelope/](http://schemas.xmlsoap.org/soap/envelope/)">
  soap:Body
    <getProductDetails xmlns="[http://warehouse.example.com/ws](http://warehouse.example.com/ws)">
      <productID>12345</productID>
    </getProductDetails>
  </soap:Body>
</soap:Envelope>

*/