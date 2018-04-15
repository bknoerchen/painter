#pragma once

class Command {
public:
	Command() {}
	virtual ~Command() {}

	virtual void execute() = 0;
	virtual void undo() = 0;
	virtual void setUndoPoint() = 0;
	virtual void restoreUndoPoint() = 0;
};
