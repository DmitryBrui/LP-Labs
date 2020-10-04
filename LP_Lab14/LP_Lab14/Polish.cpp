#include "stdafx.h"
#include "LexAn.h"
#include <stack>
#include <queue>

using namespace std;

bool PolishNotation(int i, Lex::LEX& lex)
{
	stack<LT::Entry> stack;		// ���� ��� ��������
	queue<LT::Entry> queue;		// ������� ��� ���������
	LT::Entry temp;				// ����������� �������, ��� ������ �������� ����� ���������� �� ���
	temp.idxTI = -1;
	temp.lexema = '#';
	temp.sn = -1;
	LT::Entry func;
	func.lexema = '@';
	int countLex = 0;			// ���������� ��������������� ������
	int posLex = i;				// ���������� ����� ������� ����� ���������������
	bool findFunc = false;

	for (i; lex.lextable.table[i].lexema != LEX_SEMICOLON; i++, countLex++)
	{
		switch (lex.lextable.table[i].lexema)
		{
		case LEX_ID:	// ���� �������������
		{
			queue.push(lex.lextable.table[i]);
			continue;
		}
		case LEX_LITERAL:		// ���� �������
		{
			queue.push(lex.lextable.table[i]);	// �������� � �������
			continue;
		}
		case LEX_LEFTTHESIS:		// ���� (
		{
			if (lex.idtable.table[lex.lextable.table[i - 1].idxTI].idtype == IT::F)
				findFunc = true;
			stack.push(lex.lextable.table[i]); // �������� �� � ����
			continue;
		}
		case LEX_RIGHTTHESIS:	// ���� )
		{
			if (findFunc) 
			{
				stack.push(func);
				findFunc = false;
			}
			while (stack.top().lexema != LEX_LEFTTHESIS)	// ���� �� �������� (
			{
				queue.push(stack.top());	// ����������� �� ����� � �������
				stack.pop();

				if (stack.empty())
					return false;
			}
			stack.pop();	// ���������� (
			continue;
		}
		case LEX_OPERATOR:	// ���� ���� ���������
		{
			while (!stack.empty() && lex.lextable.table[i].priority <= stack.top().priority)	// ���� ��������� �������� ��������� 
																								//������ ��� ����� ���������� ��������� � ������� �����
			{
				queue.push(stack.top());	// ����������� �� ����� � �������� ������
				stack.pop();
			}
			stack.push(lex.lextable.table[i]);
			continue;
		}
		}
	}
	while (!stack.empty())	// ���� ���� �� ������
	{
		if (stack.top().lexema == LEX_LEFTTHESIS || stack.top().lexema == LEX_RIGHTTHESIS)
			return false;
		queue.push(stack.top());	// ����������� ��� � �������
		stack.pop();
	}
	while (countLex != 0)		// ������ �������� ��������� � ������� ������ �� ��������� � �����
	{
		if (!queue.empty()) {
			lex.lextable.table[posLex++] = queue.front();
			//cout << lex.idtable.table[queue.front().idxTI].id;	// ����� � �������
			queue.pop();
		}
		else
		{
			lex.lextable.table[posLex++] = temp;			// ����� ����� ������������ �������?
		}
		countLex--;
	}

	for (int i = 0; i < posLex; i++)		// �������������� �������� ������� ��������� � ������� ������ � ���������� �� ������� ���������������
	{
		if (lex.lextable.table[i].lexema == LEX_OPERATOR || lex.lextable.table[i].lexema == LEX_LITERAL)
			lex.idtable.table[lex.lextable.table[i].idxTI].idxfirstLE = i;
	}
	return true;
}

void PolishStart(Lex::LEX lex)
{
	for (int i = 0; i < lex.lextable.size; i++)
	{
		if (lex.lextable.table[i].lexema == '=')
		{
			PolishNotation(i, lex);
		}
	}
}