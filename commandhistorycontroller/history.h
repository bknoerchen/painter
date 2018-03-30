#pragma once

#include <QVector>

class Command;

class History {
public:
	History();
	~History();

	void clear();
	void save();
	bool modified();
	void limit(int numCommands);
	void add(Command * command, bool execute);
	void revert();
	void undo();
	void redo();

private:
	QVector<Command *> history_;
	int lastExecuted_;
	int lastSaved_;
};
