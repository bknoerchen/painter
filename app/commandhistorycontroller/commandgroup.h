#pragma once

#include <QVector>
#include "command.h"

class CommandGroup : public Command
{
public:
	~CommandGroup();

	void add(Command * command);
	void execute() override;
	void undo() override;

private:
	std::vector<Command *> commands_;
};
