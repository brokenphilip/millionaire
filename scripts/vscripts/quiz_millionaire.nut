// == VScript for quiz_millionaire (original map by Doodle64) by brokenphilip ==
// https://github.com/brokenphilip/millionaire

// Question format (* - optional, mind the commas after the closing square bracket):
// ["Question", "Right answer", "Wrong answer 1", "Wrong answer 2", "Wrong answer 3", "Wrong answer 4"*, ...*, "Wrong answer N"*]

// Preserve questions between rounds. Restart the map if you want to update them!
if (!("easy_questions" in getroottable())) IncludeScript("millionaire/easy")
if (!("medium_questions" in getroottable())) IncludeScript("millionaire/medium")
if (!("hard_questions" in getroottable())) IncludeScript("millionaire/hard")
if (!("final_questions" in getroottable())) IncludeScript("millionaire/final")

// Generates a sequence of indexes of an array, for use with non-repeat RNG
function generateRandIdx(arr)
{
    local indexes = array(arr.len())
    for (local i = 0; i < arr.len(); i += 1)
        indexes[i] = i

    return indexes
}

// Preserve the index sequences between rounds,
if (!("easy_randidx" in getroottable())) ::easy_randidx <- generateRandIdx(easy_questions)
if (!("medium_randidx" in getroottable())) ::medium_randidx <- generateRandIdx(medium_questions)
if (!("hard_randidx" in getroottable())) ::hard_randidx <- generateRandIdx(hard_questions)
if (!("final_randidx" in getroottable())) ::final_randidx <- generateRandIdx(final_questions)

// Retreives a random number from an index sequence, then remove it
function getRandIdx(indexes)
{
    local rand = RandomInt(0, indexes.len() - 1)
    local index = indexes[rand]
    indexes.remove(rand)

    return index
}

// Retreives a question with the specified difficulty
function getQuestion(level)
{
    local index
    local question
    switch (level)
    {
        case 0:
			// Regenerate the index sequence if we've run out
            if (easy_randidx.len() == 0)
                easy_randidx = generateRandIdx(easy_questions)
            index = getRandIdx(easy_randidx)
            question = easy_questions[index]
            break
        case 1:
            if (medium_randidx.len() == 0)
                medium_randidx = generateRandIdx(medium_questions)
            index = getRandIdx(medium_randidx)
            question = medium_questions[index]
            break
        case 2:
            if (hard_randidx.len() == 0)
                hard_randidx = generateRandIdx(hard_questions)
            index = getRandIdx(hard_randidx)
            question = hard_questions[index]
            break
        case 3:
            if (final_randidx.len() == 0)
                final_randidx = generateRandIdx(final_questions)
            index = getRandIdx(final_randidx)
            question = final_questions[index]
            break
    }

	// A question needs to have at least 5 parameters (question, right answer and 3 wrong answers)
    Assert(question.len() > 4, "Question (level: " + level + ", index: " + index + ") is missing arguments")

	// Collect all the possible wrong answers
    local max_wrong_ans = question.len() - 2
    local wrong_ans = array(max_wrong_ans)
    for (local i = 2; i < question.len(); i += 1)
        wrong_ans[i-2] = question[i]

	// Then pick out a few using non-repeat RNG from index sequences
    local wrong_ans_randidx = generateRandIdx(wrong_ans)
    local wrong_ans1 = wrong_ans[getRandIdx(wrong_ans_randidx)]
    local wrong_ans2 = wrong_ans[getRandIdx(wrong_ans_randidx)]
    local wrong_ans3 = wrong_ans[getRandIdx(wrong_ans_randidx)]

    local table = {}
    table.question <- question[0]
    table.right_ans <- question[1]
    table.wrong_ans1 <- wrong_ans1
    table.wrong_ans2 <- wrong_ans2
    table.wrong_ans3 <- wrong_ans3
    return table
}

// Adds newlines to the passed string if it's too long:
// Replaces the next space found after the 64th character with a newline
// ...and does so until the remaining string is shorter than 96 characters
function maybeMakeMultiline(str)
{
    local length = str.len()
    if (length <= 96)
        return str

    local str_multi = ""
    local lastidx = 0
    while (length > 96)
    {
        local lastidx2 = str.find(" ", lastidx + 64)
        local split = str.slice(lastidx, lastidx2) + "\n"
        lastidx = lastidx2
        str_multi += split
        length -= split.len()
    }
	local split = str.slice(lastidx)
    str_multi += split
    return str_multi
}

// Called by question handling logic_relays in the map
// Map logic is responsible for managing the current level and picking a random option from A to D
function onQuestion(level, option)
{
    local qtable = getQuestion(level)
    local question = maybeMakeMultiline(qtable.question)

	// For game_text entities' names
	// Format: tX_qY_Z
	//   X = level, 0 for easy -> 3 for final
	//   Y = (correct) option, 1 for A -> 4 for D
	//   Z = "q" for question, "a" for answer
	
    local ent = null
    while (ent = Entities.FindByName(ent, "t" + level + "_q" + option + "_q"))
        NetProps.SetPropString(ent, "m_iszMessage", question)

    local right_ans = maybeMakeMultiline(qtable.right_ans)
    local wrong_ans1 = maybeMakeMultiline(qtable.wrong_ans1)
    local wrong_ans2 = maybeMakeMultiline(qtable.wrong_ans2)
    local wrong_ans3 = maybeMakeMultiline(qtable.wrong_ans3)

    local answers
	local answers2
    switch (option)
    {
        case 1:
            answers = "A) " + right_ans + "\nB) " + wrong_ans1 + "\nC) " + wrong_ans2 + "\nD) " + wrong_ans3
			answers2 = "A) " + qtable.right_ans + "\nB) " + qtable.wrong_ans1 + "\nC) " + qtable.wrong_ans2 + "\nD) " + qtable.wrong_ans3
            break;
        case 2:
            answers = "A) " + wrong_ans1 + "\nB) " + right_ans + "\nC) " + wrong_ans2 + "\nD) " + wrong_ans3
			answers2 = "A) " + qtable.wrong_ans1 + "\nB) " + qtable.right_ans + "\nC) " + qtable.wrong_ans2 + "\nD) " + qtable.wrong_ans3
            break;
        case 3:
            answers = "A) " + wrong_ans1 + "\nB) " + wrong_ans2 + "\nC) " + right_ans + "\nD) " + wrong_ans3
			answers2 = "A) " + qtable.wrong_ans1 + "\nB) " + qtable.wrong_ans2 + "\nC) " + qtable.right_ans + "\nD) " + qtable.wrong_ans3
            break;
        case 4:
            answers = "A) " + wrong_ans1 + "\nB) " + wrong_ans2 + "\nC) " + wrong_ans3 + "\nD) " + right_ans
			answers2 = "A) " + qtable.wrong_ans1 + "\nB) " + qtable.wrong_ans2 + "\nC) " + qtable.wrong_ans3 + "\nD) " + qtable.right_ans
            break;
    }

    local ent = null
    while (ent = Entities.FindByName(ent, "t" + level + "_q" + option + "_a"))
        NetProps.SetPropString(ent, "m_iszMessage", answers)

	// TODO: delay by two seconds (use if game_text doesn't display properly/conflicts with server plugins)
    //ClientPrint(null, 3, "\x07" + "7777FF[Quiz] \x07" + "BBBBFF" + qtable.question)
    //ClientPrint(null, 3, "\x07" + "BBBBFF" + answers2)
}