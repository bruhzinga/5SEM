#include <string>
#include <Windows.h>
#pragma once

using namespace std;

string GetErrorMsgText(int code)
{
	string msgText;
	switch (code) {
	case WSAEINTR: msgText = "������ ������� ��������"; break;
	case WSAEACCES:	msgText = "���������� ����������"; break;
	case WSAEFAULT: msgText = "��������� �����"; break;
	case WSAEINVAL:	msgText = "������ � ���������";	break;
	case WSAEMFILE:	msgText = "������� ������� ����� ������"; break;
	case WSAEWOULDBLOCK: msgText = "������ �������� ����������"; break;
	case WSAEINPROGRESS: msgText = "�������� � �������� ��������"; break;
	case WSAEALREADY: msgText = "�������� ��� �����������";	break;
	case WSAENOTSOCK: msgText = "����� ����� �����������"; break;
	case WSAEDESTADDRREQ: msgText = "��������� ����� ������������"; break;
	case WSAEMSGSIZE: msgText = "��������� ������� �������"; break;
	case WSAEPROTOTYPE: msgText = "������������ ��� ��������� ��� ������"; break;
	case WSAENOPROTOOPT: msgText = "������ � ����� ���������"; break;
	case WSAEPROTONOSUPPORT: msgText = "�������� �� ��������������"; break;
	case WSAESOCKTNOSUPPORT: msgText = "��� ������ �� ��������������"; break;
	case WSAEOPNOTSUPP: msgText = "�������� �� ��������������"; break;
	case WSAEPFNOSUPPORT: msgText = "��� ���������� �� ��������������"; break;
	case WSAEAFNOSUPPORT: msgText = "��� ������� �� �������������� ����������"; break;
	case WSAEADDRINUSE: msgText = "����� ��� ������������"; break;
	case WSAEADDRNOTAVAIL: msgText = "����������� ����� �� ����� ���� �����������"; break;
	case WSAENETDOWN: msgText = "���� ���������"; break;
	case WSAENETUNREACH: msgText = "���� �� ���������"; break;
	case WSAENETRESET: msgText = "���� ��������� ����������"; break;
	case WSAECONNABORTED: msgText = "����������� ����� �����"; break;
	case WSAECONNRESET: msgText = "����� �� �������������"; break;
	case WSAENOBUFS: msgText = "�� ������� ������ ��� �������"; break;
	case WSAEISCONN: msgText = "����� ��� ���������"; break;
	case WSAENOTCONN: msgText = "����� �� ���������"; break;
	case WSAESHUTDOWN: msgText = "������ ��������� send: ����� �������� ������"; break;
	case WSAETIMEDOUT: msgText = "���������� ���������� �������� �������"; break;
	case WSAECONNREFUSED: msgText = "���������� ���������"; break;
	case WSAEHOSTDOWN: msgText = "���� � ����������������� ���������"; break;
	case WSAEHOSTUNREACH: msgText = "��� �������� ��� �����"; break;
	case WSAEPROCLIM: msgText = "������� ����� ���������"; break;
	case WSASYSNOTREADY: msgText = "���� �� ��������"; break;
	case WSAVERNOTSUPPORTED: msgText = "������ ������ ����������"; break;
	case WSANOTINITIALISED: msgText = "�� ��������� ������������� WS2_32.dll"; break;
	case WSAEDISCON: msgText = "����������� ����������"; break;
	case WSATYPE_NOT_FOUND: msgText = "����� �� ������"; break;
	case WSAHOST_NOT_FOUND: msgText = "���� �� ������"; break;
	case WSATRY_AGAIN: msgText = "���������������� ���� �� ������"; break;
	case WSANO_RECOVERY: msgText = "�������������� ������"; break;
	case WSANO_DATA: msgText = "��� ������ ������������ ����"; break;
	case WSASYSCALLFAILURE: msgText = "��������� ���������� ���������� ������"; break;
	case 2: msgText = "��������� ����������"; break;
	case ERROR_INVALID_PARAMETER: msgText = "�������� ��������� pimax ����������� ��������  PIPE_UNLMITED_INSTANCES"; break;
	case ERROR_NO_DATA: msgText = "The pipe is being closed"; break;
	case ERROR_PIPE_CONNECTED: msgText = "There is a process on other end of the pipe"; break;
	case ERROR_PIPE_LISTENING: msgText = "Waiting for a process to open the other end of the pipe"; break;
	case ERROR_CALL_NOT_IMPLEMENTED: msgText = "This function is not supported on this system"; break;
	case ERROR_INVALID_NAME: msgText = "The filename, directory name, or volume label syntax is incorrect."; break;
	case ERROR_SEM_TIMEOUT: msgText = "The semaphore timeout period has expired."; break;
	case ERROR_ALREADY_EXISTS: msgText = "Cannot create a file when that file already exists."; break;
	default: msgText = "Error..."; break;
	}

	return msgText;
}

string SetPipeError(string msgText, int code) {
	return msgText + GetErrorMsgText(code) + "\n\n";
}