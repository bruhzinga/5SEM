#pragma once
#include <processthreadsapi.h>
#include <WinBase.h>
#include <iostream>
#include <bitset>
using namespace std;
void getProcessPriority(HANDLE hp)
{
	//��������� ������������ �����) �������� ��������;
	int priority = GetPriorityClass(hp);
	switch (priority)
	{
	case IDLE_PRIORITY_CLASS:
		cout << "Priority: IDLE_PRIORITY_CLASS" << endl;
		break;
	case BELOW_NORMAL_PRIORITY_CLASS:
		cout << "Priority: BELOW_NORMAL_PRIORITY_CLASS" << endl;
		break;
	case NORMAL_PRIORITY_CLASS:
		cout << "Priority: NORMAL_PRIORITY_CLASS" << endl;
		break;
	case ABOVE_NORMAL_PRIORITY_CLASS:
		cout << "Priority: ABOVE_NORMAL_PRIORITY_CLASS" << endl;
		break;
	case HIGH_PRIORITY_CLASS:
		cout << "Priority: HIGH_PRIORITY_CLASS" << endl;
		break;
	case REALTIME_PRIORITY_CLASS:
		cout << "Priority: REALTIME_PRIORITY_CLASS" << endl;
		break;
	}
}

void getThreadPriority(HANDLE ht)
{
	//��������� �������� ������;
	int priority = GetThreadPriority(ht);
	switch (priority)
	{
	case THREAD_PRIORITY_IDLE:
		cout << "Thread priority: THREAD_PRIORITY_IDLE" << endl;
		break;
	case THREAD_PRIORITY_LOWEST:
		cout << "Thread priority: THREAD_PRIORITY_LOWEST" << endl;
		break;
	case THREAD_PRIORITY_BELOW_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_BELOW_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_ABOVE_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_ABOVE_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_HIGHEST:
		cout << "Thread priority: THREAD_PRIORITY_HIGHEST" << endl;
		break;
	case THREAD_PRIORITY_TIME_CRITICAL:
		cout << "Thread priority: THREAD_PRIORITY_TIME_CRITICAL" << endl;
		break;
	}
}

void getAffinityMask(HANDLE hp, HANDLE ht)
{
	//����� affinity mask) ��������� �������� ����������� � �������� ����;
	DWORD_PTR mask;
	DWORD_PTR systemMask;
	GetProcessAffinityMask(hp, &mask, &systemMask);
	cout << "Process affinity mask: ";
	std::cout << std::bitset<12>{mask} << '\n';
	cout << "System affinity mask: ";
	std::cout << std::bitset<12>{systemMask} << '\n';
	//���������� ����������� ��������� ��������;
	int count = 0;
	for (int i = 0; i < 12; i++)
	{
		if (mask & (1 << i))
			count++;
	}
	cout << "Number of processors available to the process: " << count << endl;

	//���������, ����������� �������� ������
	DWORD_PTR processor = GetCurrentProcessorNumber();
	cout << "Processor assigned to the current thread: " << processor << endl;
}