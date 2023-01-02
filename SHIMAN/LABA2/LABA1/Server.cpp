#include <iostream>
#include <clocale>
#include <ctime>
#include <chrono>

#include "ErrorMsgText.h"
#include "Winsock2.h"                
#pragma comment(lib, "WS2_32.lib")   

int main()
{
    setlocale(LC_ALL, "rus");

    WSADATA wsaData;                //метадата
    SOCKET  sS;

    SOCKADDR_IN serv;               // структура для хранения параметров сокета sS
    serv.sin_family = AF_INET;      // тип используемого адреса (AF_INET = семейство IP)
    serv.sin_port = htons(2000);    // номер порта
    serv.sin_addr.s_addr = INADDR_ANY;      // любой собственный IP адрес

    try {
        std::cout << "ServerT\n\n";

        // инициализация библиотеки WS2_32.lib; параметры: версия Windows Sockets, указатель на WSADATA
        if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0) {
            throw  SetErrorMsgText("Startup: ", WSAGetLastError());
        }

        // создание сокета сервера; SOCK_STREAM - тип сокета (ориентированный на поток, устанавливается соединение); NULL - параметр, определяющий протокол, для TCP/IP можно оставить NULL
        if ((sS = socket(AF_INET, SOCK_STREAM, NULL)) == INVALID_SOCKET) {
            throw  SetErrorMsgText("socket: ", WSAGetLastError());
        }
        // связывание сокета с параметрами (сокет, указатель на его параметры, длина параметров в байтах)
        if (bind(sS, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR) {
            throw  SetErrorMsgText("bind: ", WSAGetLastError());
        }

        // перевод сокета в состояние прослушивания, отквывает доступ к нему (связанный сокет, максимальная длина очереди)
        if (listen(sS, SOMAXCONN) == SOCKET_ERROR) {
            throw SetErrorMsgText("listen: ", WSAGetLastError());
        }

        SOCKET cS;      // сокет клиента
        SOCKADDR_IN clnt;       // параметры сокета клиента
        memset(&clnt, 0, sizeof(clnt));     // очистка параметров сокета клиента
        int lclnt = sizeof(clnt);

        clock_t start, end;     // время начала и конца обмена данными с клиентом
        char ibuf[50],                          // буфер ввода
            obuf[50] = "server: принято ";      // буфер вывода
        int libuf = 0,              // количество принятых байт
            lobuf = 0;              // количество отправленных байт
        bool flag = true;

        while (true) {
            // установка соединения с клиентом (состояние ожидания, пока клиент не совершит connect(...); если все корректно, функция возвращает новый сокет
            if ((cS = accept(sS, (sockaddr*)&clnt, &lclnt)) == INVALID_SOCKET) {
                throw SetErrorMsgText("accept: ", WSAGetLastError());
            }
            else {
                std::cout << "\n--------------- NEW CLIENT------------\n\n";
            }

            while (true) {

                // перессылка данных клиенту (сокет клиента, буфер данных, кол-во байт данных в буфере, флаг (буфер очищается после считывания данных))
                if ((libuf = recv(cS, ibuf, sizeof(ibuf), NULL)) == SOCKET_ERROR) {
                    if (WSAGetLastError() == WSAECONNRESET) {
                        end = clock();
                        flag = true;
                        std::cout << "\n---- CLIENT CONNECTION WAS RESET after " << ((double)(end - start) / CLK_TCK) << " seconds of recv/send excange ----\n";
                        break;
                    }
                    else throw SetErrorMsgText("recv: ", WSAGetLastError());
                }
                else {
                    if (flag) {
                        start = clock();
                        flag = !flag;
                    }
                }

                std::string obuf = ibuf;
                if ((lobuf = send(cS, obuf.c_str(), strlen(obuf.c_str()) + 1, NULL)) == SOCKET_ERROR) {
                    throw SetErrorMsgText("send: ", WSAGetLastError());
                }

                if (strcmp(ibuf, "") == 0) {
                    flag = true;
                    end = clock();
                    std::cout << "Exchange took " << ((double)(end - start) / CLK_TCK) << " c\n\n";
                    break;
                }
                else {
                    std::cout << ibuf << std::endl;
                 
                    
                }
            }
        }

        if (closesocket(cS) == SOCKET_ERROR) {
            throw  SetErrorMsgText("closesocket: ", WSAGetLastError());
        }
        if (closesocket(sS) == SOCKET_ERROR) {
            throw  SetErrorMsgText("closesocket: ", WSAGetLastError());
        }
        if (WSACleanup() == SOCKET_ERROR) {
            throw  SetErrorMsgText("Cleanup: ", WSAGetLastError());
        }
    }
    catch (std::string errorMsgText) {
        WSACleanup();
        std::cout << '\n' << errorMsgText;
    }

    system("pause");
    return 0;
}