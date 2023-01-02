#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <iostream>
#include <string>

#include "Winsock2.h"
#include "ErrorMSG.h"
#pragma comment(lib, "WS2_32.lib")

using namespace std;

int countServers = 1;
bool GetRequestFromClient(char* name, short port, struct sockaddr* from, int* flen);
bool PutAnswerToClient(char* name, struct sockaddr* to, int* lto);
void GetServer(char* call, short port, struct sockaddr* from, int* flen);

SOCKET sS;

int main(int argc, char* argv[])
{
	// позывной сервера
	char NAME[6] = "Hello";
	WSADATA wsaData;
	SOCKADDR_IN server;
	SOCKADDR_IN client;

	server.sin_family = AF_INET;
	server.sin_port = htons(2000);
	server.sin_addr.s_addr = INADDR_ANY;

	memset(&client, 0, sizeof(client));
	int lclient = sizeof(client);
	int lserver = sizeof(server);

	int optval = 1;

	cout << "Server callsign: " << NAME << endl;
	try
	{
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)                              throw SetErrorMsgText("Startup:", WSAGetLastError());

		GetServer(NAME, 2000, (sockaddr*)&client, &lclient);
		if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)             throw SetErrorMsgText("socket:", WSAGetLastError());
		if (bind(sS, (LPSOCKADDR)&server, sizeof(server)) == SOCKET_ERROR)          throw SetErrorMsgText("bind:", WSAGetLastError());

		char serverhostname[128] = "";
		if (gethostname(serverhostname, sizeof(serverhostname)) == SOCKET_ERROR)    throw SetErrorMsgText("gethostname:", WSAGetLastError());
		cout << "Server Hostname: " << serverhostname << endl;

		while (true)
		{
			if (GetRequestFromClient(NAME, htons(2000), (sockaddr*)&client, &lclient)) {
				// если успешно обработан запрос, отправляем ответ
				PutAnswerToClient(NAME, (sockaddr*)&client, &lclient);
				hostent* chostname = gethostbyaddr((char*)&client.sin_addr, sizeof(client.sin_addr), AF_INET);
				cout << "Client Hostname: " << chostname->h_name << endl;
			}
		}

		if (closesocket(sS) == SOCKET_ERROR)             throw SetErrorMsgText("closesocket:", WSAGetLastError());
		if (WSACleanup() == SOCKET_ERROR)                throw SetErrorMsgText("Cleanup:", WSAGetLastError());
	}
	catch (string errorMsgText)
	{
		cout << endl << "WSAGetLastError: " << errorMsgText;
	}
	return 0;
}

// обработать запрос клиента: true если пришел запрос, иначе false
// параметры: позывной сервера, номер порта, указатель на параметры, указатель на размер параметров
bool GetRequestFromClient(char* name, short port, struct sockaddr* from, int* flen) {
	char bfrom[50];
	try {
		while (true) {
			// ожидание запроса от клиента
			if (recvfrom(sS, bfrom, sizeof(bfrom), NULL, from, flen) == SOCKET_ERROR) throw SetErrorMsgText("GetRequestFromClient recvfrom: ", WSAGetLastError());

			// если позывной сервера совпал с сообщением от клиента
			if (strcmp(name, bfrom) == 0) {
				cout << endl << "Client IP: " << inet_ntoa(((struct sockaddr_in*)from)->sin_addr) << endl;//?
				cout << "Client Port: " << ntohs(((struct sockaddr_in*)from)->sin_port) << endl;//?
				return true;
			}
		}
	}
	catch (string errorMsgText)
	{
		if (WSAGetLastError() == WSAETIMEDOUT) return false;
		throw SetErrorMsgText("GetRequestFromClient:", WSAGetLastError());
	}
}

// ответ на запрос клиента, true если успешно
bool PutAnswerToClient(char* name, struct sockaddr* to, int* lto) {
	try
	{
		// сервер отправляет свой позывной
		if ((sendto(sS, name, strlen(name) + 1, NULL, to, *lto)) == SOCKET_ERROR)   throw SetErrorMsgText("sendto:", WSAGetLastError());
		return true;
	}
	catch (string errorMsgText)
	{
		throw SetErrorMsgText("PutAnswerToClient: ", WSAGetLastError());
	}
	return false;
}

// широковеещательный запрос всем узлам сети с позывным сервера
void GetServer(char* call, short port, struct sockaddr* from, int* flen) {
	SOCKET cC;
	SOCKADDR_IN all;

	int timeout = 5000;

	int optval = 1;
	char buf[50];

	try {
		if ((cC = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
			throw  SetErrorMsgText("socket:", WSAGetLastError());

		// установка режима работы сокета: для использования широковещательного адреса нужен SO_BROADCAST
		if (setsockopt(cC, SOL_SOCKET, SO_BROADCAST, (char*)&optval, sizeof(int)) == SOCKET_ERROR)
			throw  SetErrorMsgText("setsocketopt:", WSAGetLastError());
		if (setsockopt(cC, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(int)) == SOCKET_ERROR)
			throw  SetErrorMsgText("setsocketopt:", WSAGetLastError());

		all.sin_family = AF_INET;
		all.sin_port = htons(port);
		all.sin_addr.s_addr = INADDR_BROADCAST; // широковещательный адрес

		// отправка широковещательного запроса с позывным
		if (sendto(cC, call, strlen(call) + 1, NULL, (sockaddr*)&all, sizeof(all)) == SOCKET_ERROR)
			throw SetErrorMsgText("sendto:", WSAGetLastError());
		// ожидание ответа
		if (recvfrom(cC, buf, sizeof(buf), NULL, from, flen) == SOCKET_ERROR)
			throw  SetErrorMsgText("recvfrom:", WSAGetLastError());

		// если позывные совпадают
		if (strcmp(call, buf) == 0) {
			countServers++;
			cout << "Server N" << countServers;
			hostent* shostname = gethostbyaddr((char*)&((SOCKADDR_IN*)from)->sin_addr, sizeof(SOCKADDR_IN), AF_INET);
			cout << "\tIP: " << inet_ntoa(((SOCKADDR_IN*)from)->sin_addr) << endl;
			cout << "\t\tPort: " << ntohs(((struct sockaddr_in*)from)->sin_port) << endl;
			cout << "\t\tHostname: " << shostname->h_name << endl;
		}
	}
	catch (string errorMsgText)
	{
		if (WSAGetLastError() == WSAETIMEDOUT) {
			cout << "Total number of servers with that callsign: " << countServers << endl;
			if (closesocket(cC) == SOCKET_ERROR) throw SetErrorMsgText("closesocket: ", WSAGetLastError());
		}
		else throw SetErrorMsgText("GetServer:", WSAGetLastError());
	}
}