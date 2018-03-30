#include "history.h"

#include "command.h"

History::History()
    : lastExecuted_(-1)
    , lastSaved_(-1)
{
}

History::~History()
{
	for (auto command : history_) {
		delete command;
	}
}

void History::clear()
{
	for (auto command : history_) {
		delete command;
	}
	history_.clear();
	lastExecuted_ = -1;
	lastSaved_ = -1;
}

void History::save()
{
	lastSaved_ = lastExecuted_;
}

bool History::modified()
{
	return lastSaved_ != lastExecuted_;
}

void History::limit(int numCommands)
{
	while (history_.size() > numCommands) {
		delete history_[0];
		history_.erase(history_.begin());
		if (lastExecuted_ >= 0) {
			lastExecuted_--;
		}
		if (lastSaved_ >= 0) {
			lastSaved_--;
		}
	}
}

void History::add(Command * command, bool execute)
{
	// Remove all commands in the branch that is "cut off" by adding a new command after undo.
	if (lastExecuted_ + 1 < history_.size()) {
		int count = history_.size() - (lastExecuted_ + 1);
		int begin = lastExecuted_ + 1;
		int end = begin + count;

		for (int i = 0; i < count; i++) {
			delete history_.value(begin + i);
		}

		history_.erase(history_.begin() + begin, history_.begin() + end);
		lastSaved_ = -1;
	}

	if ( execute ) {
		command->execute();
	}

	history_.push_back(command);
	lastExecuted_ = history_.size() - 1;
}

void History::revert()
{
	while (lastExecuted_ > 0) {
		history_.value(lastExecuted_)->undo();
		lastExecuted_--;
	}
}

void History::undo() {
	if (lastExecuted_ >= 0) {
		if (history_.size() > 0) {
			history_.value(lastExecuted_)->undo();
			lastExecuted_--;
		}
	}
}

void History::redo()
{
	if (lastExecuted_ + 1 < history_.size()) {
		history_.value(lastExecuted_ + 1)->execute();
		lastExecuted_++;
	}
}
