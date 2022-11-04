alter table big_table parallel; -- позволяем ораклу самому динамически определять степерь параллелизма
alter table big_table parallel 4; -- при создании плана нас интересует степень параллелизма 4.