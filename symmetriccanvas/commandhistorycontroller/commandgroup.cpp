#include "commandgroup.h"

CommandGroup::~CommandGroup()
{
	for (auto command : commands_) {
		delete command;
	}
}

void CommandGroup::add(Command * command)
{
	commands_.push_back(command);
}

void CommandGroup::execute()
{
	for ( unsigned int i=0; i < commands_.size(); i++ ) {
		commands_.at(i)->execute();
	}
}

void CommandGroup::undo()
{
	for ( unsigned int i=0; i < commands_.size(); i++ ) {
		commands_.at(i)->undo();
	}
}

