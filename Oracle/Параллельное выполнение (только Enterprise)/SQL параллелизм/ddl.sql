-- Параллельная прямая загрузка
create table new_table parallel as select a.*,
					                      b.user_id,
					                      b.created user_created
									 from big_table a,
								          user_info b
									where a.owner = b.username;