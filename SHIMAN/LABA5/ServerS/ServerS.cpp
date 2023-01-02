// ServerS.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <iostream>
#include <WinSock2.h>
#include <string>
#include <time.h>
#pragma comment(lib, "WS2_32.lib")   // экспорт  WS2_32.dll

#define CASE(i) case i:msgText=#i; break
#define MAX_SIZE_OF_MSG 50

using namespace std;

string GetErrorMsgText(int code)    // cформировать текст ошибки
{
	string msgText;
	switch (code)                      // проверка кода возврата
	{
		CASE(WSAEINTR);
		CASE(WSAEACCES);
		CASE(WSAEFAULT);
		CASE(WSAEINVAL);
		CASE(WSAEMFILE);
		CASE(WSAEWOULDBLOCK);
		CASE(WSAEINPROGRESS);
		CASE(WSAEALREADY);
		CASE(WSAENOTSOCK);
		CASE(WSAEDESTADDRREQ);
		CASE(WSAEMSGSIZE);
		CASE(WSAEPROTOTYPE);
		CASE(WSASYSCALLFAILURE);
		CASE(WSAENOPROTOOPT);
		CASE(WSAEPROTONOSUPPORT);
		CASE(WSAESOCKTNOSUPPORT);
		CASE(WSAEOPNOTSUPP);
		CASE(WSAEPFNOSUPPORT);
		CASE(WSAEAFNOSUPPORT);
		CASE(WSAEADDRINUSE);
		CASE(WSAEADDRNOTAVAIL);
		CASE(WSAENETDOWN);
		CASE(WSAENETUNREACH);
		CASE(WSAENETRESET);
		CASE(WSAECONNABORTED);
		CASE(WSAECONNRESET);
		CASE(WSAENOBUFS);
		CASE(WSAEISCONN);
		CASE(WSAENOTCONN);
		CASE(WSAESHUTDOWN);
		CASE(WSAETIMEDOUT);
		CASE(WSAECONNREFUSED);
		CASE(WSAEHOSTDOWN);
		CASE(WSAEHOSTUNREACH);
		CASE(WSAEPROCLIM);
		CASE(WSASYSNOTREADY);
		CASE(WSAVERNOTSUPPORTED);
		CASE(WSANOTINITIALISED);
		CASE(WSAEDISCON);
		CASE(WSATYPE_NOT_FOUND);
		CASE(WSAHOST_NOT_FOUND);
		CASE(WSATRY_AGAIN);
		CASE(WSANO_RECOVERY);
		CASE(WSANO_DATA);
		CASE(WSA_INVALID_HANDLE);
		CASE(WSA_INVALID_PARAMETER);
		CASE(WSA_IO_INCOMPLETE);
		CASE(WSA_IO_PENDING);
		CASE(WSA_NOT_ENOUGH_MEMORY);
		CASE(WSA_OPERATION_ABORTED);
	default:                msgText = "***ERROR***";      break;
	};
	return msgText;
};

string  SetErrorMsgText(string msgText, int code)
{
	return msgText + GetErrorMsgText(code);
};

SOCKET sS;

bool GetRequestFromClient(const char* name, short port, sockaddr* from, int* flen)
{
	SOCKADDR_IN serv;
	serv.sin_family = AF_INET;
	serv.sin_port = htons(port);
	serv.sin_addr.s_addr = INADDR_ANY;

	if (bind(sS, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR)
		throw  SetErrorMsgText("bind:", WSAGetLastError());

	char* message = new char[strlen(name)];
	int buf = 0;
	SOCKADDR_IN client;
	int size = sizeof(client);

	while (strcmp(name, message))
	{
		memset(&client, 0, size);
		buf = recvfrom(sS, message, strlen(message), NULL, (sockaddr*)&client, &size);

		char* addr = (char*)&client.sin_addr;
		hostent* cl = gethostbyaddr(addr, 4, AF_INET);
		cout << "Имя клиента: " << cl->h_name << "\n";

		switch (buf)
		{
		case SOCKET_ERROR: throw SetErrorMsgText("recvfrom:", WSAGetLastError()); break;
		case WSAETIMEDOUT: return false;
		default: break;
		}
		message[buf] = 0x00;
	}
	*from = *((sockaddr*)&client);
	*flen = sizeof(client);

	return true;
}

bool  PutAnswerToClient(const char* name, struct sockaddr* to, int* lto)
{
	int buf = sendto(sS, name, strlen(name), NULL, to, *lto);

	switch (buf)
	{
	case SOCKET_ERROR: throw SetErrorMsgText("sendto:", WSAGetLastError()); break;
	case WSAETIMEDOUT: return false;
	default: break;
	}
	return true;
}

int main()
{
	setlocale(NULL, "Rus");
	WSADATA wsaData;

	try
	{
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
			throw  SetErrorMsgText("Startup:", WSAGetLastError());
		if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
			throw SetErrorMsgText("socket", WSAGetLastError());

		sockaddr from;
		int size = sizeof(from);
		memset(&from, NULL, size);

		char name[100];

		if (gethostname(name, sizeof(name)) == SOCKET_ERROR)
			throw SetErrorMsgText("gethostname:", WSAGetLastError());
		cout << "Привет, я Сервер! Мое имя: " << name << "\n";

		if (GetRequestFromClient("Hello", 2000, &from, &size))
		{
			cout << "OK!\n";
			PutAnswerToClient("Goodbye", &from, &size);
		}

		if (closesocket(sS) == SOCKET_ERROR)
			throw SetErrorMsgText("closesocket:", WSAGetLastError());
		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("WSACleanup:", WSAGetLastError());
	}
	catch (string txt)
	{
		cout << txt.c_str();
	}
	system("pause");
	return 0;
}