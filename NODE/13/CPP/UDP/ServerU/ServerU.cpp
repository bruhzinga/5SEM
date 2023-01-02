#include <iostream>
#include <clocale>
#include <ctime>
#include <chrono>
#include "ErrorMsgText.h"
#include "Winsock2.h"

#pragma warning(disable : 4996)
#pragma comment(lib, "WS2_32.lib")

int main()
{
	setlocale(LC_ALL, "rus");

	WSADATA wsaData;

	SOCKET  sS;
	SOCKADDR_IN serv;

	serv.sin_family = AF_INET;
	serv.sin_port = htons(2000);
	serv.sin_addr.s_addr = INADDR_ANY;

	try {
		cout << "ServerU\n\n";

		if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
			throw  SetErrorMsgText("WSAStartup: ", WSAGetLastError());
		}

		if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET) {
			throw  SetErrorMsgText("socket: ", WSAGetLastError());
		}
		auto bufferSize = 0;
		auto bufferSizeLen = sizeof(bufferSize);

		if (bind(sS, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR) {
			throw  SetErrorMsgText("bind: ", WSAGetLastError());
		}

		SOCKADDR_IN clientInfo;
		memset(&clientInfo, 0, sizeof(clientInfo));
		char ibuf[50];
		int lc = sizeof(clientInfo), lb = 0, lobuf = 0;
		while (true) {
			if ((lb = recvfrom(sS, ibuf, sizeof(ibuf), NULL, (sockaddr*)&clientInfo, &lc)) == SOCKET_ERROR) {
				throw  SetErrorMsgText("recvfrom: ", WSAGetLastError());
			}

			std::string obuf = "ECHO:";
			obuf.append(ibuf);

			if ((lobuf = sendto(sS, obuf.c_str(), strlen(obuf.c_str()) + 1, NULL, (sockaddr*)&clientInfo, lc)) == SOCKET_ERROR)
			{
				throw SetErrorMsgText("sendto: ", WSAGetLastError());
			}

			cout << ibuf << endl;
		}

		if (closesocket(sS) == SOCKET_ERROR) {
			throw  SetErrorMsgText("closesocket: ", WSAGetLastError());
		}
		if (WSACleanup() == SOCKET_ERROR) {
			throw  SetErrorMsgText("Cleanup: ", WSAGetLastError());
		}
	}
	catch (string errorMsgText) {
		cout << endl << errorMsgText;
	}

	system("pause");
	return 0;
}