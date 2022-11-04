/* 
Категории изменчивости:

1. Volatile - возвращаемое значение может произвольно меняться при одинаковых значениях входных
			  параметров. Используется по умолчанию.
			  
			  Если есть какой нибудь DML. Это 100% Volatile


2.
   Stable - Значение не меняется в пределах одного оператора SQL.
	        Функция не может менять состояние базы данных.
			
			Если нет никакого DML. Но что-то читаем из базы данных.


3.
   Immutable - Значение не меняется, функция детерминирована. Функция не может
			   менять состояние базы данных.
			   
			   Нет DML, ничего не читаем из БД, работаем только с параметрами

*/