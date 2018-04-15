#pragma once

#include <QVector>

class Command;

class History {

public:
	History();
	~History();

	int getNextExecutionNumber();
	void clear();
	void save();
	bool modified();
	void limit(int maxCommands);
	void add(Command * command, bool execute);
	void revert();
	void undoWithCachedData();
	void undo();
	void redo();

private:
	QVector<Command *> history_;
	int lastExecuted_;
	int lastSaved_;
};
