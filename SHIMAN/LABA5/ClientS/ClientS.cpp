// ClientS.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <iostream>
#include <stdio.h>
#include <WinSock2.h>
#include <cstring>
#include <time.h>

#pragma comment(lib, "WS2_32.lib")   // экспорт  WS2_32.dll
#define CASE(i) case i:msgText=#i;break
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

bool  GetServerByName(const char* name, const char* call, struct sockaddr* from, int* flen)
{
	hostent* host = gethostbyname(name);
	if (!host)
		throw SetErrorMsgText("gethostbyname:", WSAGetLastError());

	char* ip_addr = inet_ntoa(*(in_addr*)(host->h_addr));
	cout << "\nИмя хоста: " << host->h_name;
	cout << "\nIP сервера: " << ip_addr;

	SOCKADDR_IN server;
	server.sin_family = AF_INET;
	server.sin_port = htons(2000);
	server.sin_addr.s_addr = inet_addr(ip_addr);
	char message[10];

	if (sendto(sS, call, strlen(call), NULL, (const sockaddr*)&server, *flen) == SOCKET_ERROR)
		throw SetErrorMsgText("sendto:", WSAGetLastError());
	int buf = 0;

	if ((buf = recvfrom(sS, message, sizeof(message), NULL, (sockaddr*)&server, flen)) == SOCKET_ERROR)
		throw SetErrorMsgText("recvfrom:", WSAGetLastError());

	message[buf] = 0x00;
	cout << "\nСообщение от сервера: " << message << "\n";
	*from = *((sockaddr*)&server);
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
		if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == SOCKET_ERROR)
			throw SetErrorMsgText("socket:", WSAGetLastError());

		sockaddr from;
		int length = sizeof(from);
		memset(&from, 0, sizeof(from));
		GetServerByName("HOME-PC", "Hello", &from, &length);

		if (closesocket(sS) == SOCKET_ERROR)
			throw SetErrorMsgText("closesocket:", WSAGetLastError());
		if (WSACleanup() == SOCKET_ERROR)
			throw SetErrorMsgText("WSACleanup:", WSAGetLastError());
	}
	catch (string str)
	{
		printf("%s", str.c_str());
	}
	system("pause");
	return 0;
}