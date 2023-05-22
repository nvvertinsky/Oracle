# Работа с файлами сервера

### Записать файл на диск, чтобы протестировать.
````
declare
  file1 utl_file.file_type;
begin
  file1 := utl_file.fopen('ЛЮБАЯ ТЕСТОВАЯ ДИРЕКТОРИЯ', 'sample.txt', 'w');
  utl_file.put_line(file1, 'Welcome');
  utl_file.fclose(file1);
end;
````