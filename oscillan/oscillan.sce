clf();
set("auto_clear","off");

t0=2500/4

//Считывание данных из таблицы
CH = csvRead('R:\Проекты\lab3materials\F0015CH1.CSV');
CH1(:,1) = CH(:,4)
CH1(:,2) = CH(:,5)
CH = csvRead('R:\Проекты\lab3materials\F0015CH2.CSV');
CH2(:,1) = CH(:,4)
CH2(:,2) = CH(:,5) + CH(10,2)

//Ввод данных, которых нет в таблице
hz = 15
w=2*%pi*hz
n = floor(1/(hz*CH(2,2)))

//Вычисление гармоник
a0_ch1 = 2/n*sum(CH1(t0:t0+n,2))
a0_ch2 = 2/n*sum(CH2(t0:t0+n,2))

a_ch1(1) = 2/n*sum(CH1(t0:t0+n,2).*cos(CH1(t0:t0+n,1).*w))
b_ch1(1) = 2/n*sum(CH1(t0:t0+n,2).*sin(CH1(t0:t0+n,1).*w))

a_ch2(1) = 2/n*sum(CH2(t0:t0+n,2).*cos(CH2(t0:t0+n,1).*w))
b_ch2(1) = 2/n*sum(CH2(t0:t0+n,2).*sin(CH2(t0:t0+n,1).*w))
//Вычисление амплитуды первой гармоники
A_ch1(1) = sqrt(a_ch1(1)^2+b_ch1(1)^2)
A_ch2(1) = sqrt(a_ch2(1)^2+b_ch2(1)^2)
//Вычисление запаздывания по фазе
psi_ch1(1)=atan(a_ch1(1), b_ch1(1))
psi_ch2(1)=atan(a_ch2(1), b_ch2(1))
//фильтрация значений экспериментальных данных
g_ch1 = a0_ch1/2+A_ch1(1).*sin(CH1(t0:t0+n,1).*w+psi_ch1(1))
g_ch2 = a0_ch2/2+A_ch2(1).*sin(CH2(t0:t0+n,1).*w+psi_ch2(1))

//Отрисовка экспериментальных даных
plot2d(CH1(t0:t0+n,1), CH1(t0:t0+n,2), 2);
plot2d(CH2(t0:t0+n,1), CH2(t0:t0+n,2), 3);

//Отрисовка отфильтрованных данных
plot2d(CH1(t0:t0+n,1),g_ch1, 7);
plot2d(CH2(t0:t0+n,1),g_ch2, 5);

//Вычисление гармоник
i = 20
while (i > 1)
    a_ch1(i)= 2/n*sum(CH1(t0:t0+n,2).*cos(w*i.*CH1(t0:t0+n,1)))
    b_ch1(i)= 2/n*sum(CH1(t0:t0+n,2).*sin(w*i.*CH1(t0:t0+n,1)))
    a_ch2(i)= 2/n*sum(CH2(t0:t0+n,2).*cos(w*i.*CH2(t0:t0+n,1)))
    b_ch2(i)= 2/n*sum(CH2(t0:t0+n,2).*sin(w*i.*CH2(t0:t0+n,1)))
    A_ch1(i) = sqrt(a_ch1(i)^2+b_ch1(i)^2)
    A_ch2(i) = sqrt(a_ch2(i)^2+b_ch2(i)^2)
    psi_ch1(i)=atan(a_ch1(i), b_ch1(i))
    psi_ch2(i)=atan(a_ch2(i), b_ch2(i))
    i=i-1
end

//Вычисление коэффициентов гармонических искажений
KGI_ch1 = sqrt(sum(A_ch1(2:20).^2))/A_ch1(1)
KGI_ch2 = sqrt(sum(A_ch2(2:20).^2))/A_ch2(1)

mprintf("\nЧастота                w = %f Гц\n", hz)
mprintf("\nАмплитуда \n   CH1 = %f В\n   CH2 = %f В\n", A_ch1(1), A_ch2(1))
mprintf("\nОтношение амплитуд\n   CH1/СH2 = %f В\n   W(w) = %f Дб\n", A_ch2(1)/A_ch1(1), 20*log10(A_ch2(1)/A_ch1(1)))
mprintf("\nЗапаздывание по фазе   Ф(w) = %f град\n", (psi_ch1(1)-psi_ch2(1))/%pi*180)
mprintf("\nКоэффициент гармонических искажений\n   СH1 = %f\n   CH2 = %f\n", KGI_ch1, KGI_ch2)
