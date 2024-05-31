#include "SudokuModel.h"

SudokuModel* SudokuModel::m_instance = nullptr;

QObject* SudokuModel::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    if (!m_instance) {
        m_instance = new SudokuModel();
    }
    return m_instance;
}

SudokuModel::SudokuModel(QObject *parent)
    : QAbstractListModel(parent), m_board(BOARD_SIZE * BOARD_SIZE, 0), m_initialBoard(BOARD_SIZE * BOARD_SIZE, 0), m_solutionBoard(BOARD_SIZE * BOARD_SIZE, 0) // Initialize grid with zeros
{
    qDebug() << "SudokuModel constructor called.";
    loadSudokuGame(QString::number(m_level));
    initBoard();
    printBoard();
}

int SudokuModel::rowCount(const QModelIndex & /* parent */) const {
    return m_board.size();
}

QVariant SudokuModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_board.size())
        return QVariant();

    int idx = index.row();
    switch (role) {
    case ValueRole:
        return m_board[idx];
    case ReadOnlyRole:
        return m_initialBoard[idx] != 0; // True if cell was initially non-zero
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> SudokuModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ValueRole] = "value";
    roles[ReadOnlyRole] = "readOnly";
    return roles;
}

bool SudokuModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    // qDebug() << "Trying to set data at index:" << index.row() << "Value:" << value << "Role:" << role;

    if (role != ValueRole) {
        // qDebug() << "Failed to set data: Incorrect role";
        return false;
    }
    if (!index.isValid()) {
        // qDebug() << "Failed to set data: Invalid index";
        return false;
    }
    if (index.row() >= m_board.size()) {
        // qDebug() << "Failed to set data: Index out of range";
        return false;
    }
    if (data(index, ReadOnlyRole).toBool()) {
        // qDebug() << "Failed to set data: Cell is read-only";
        return false;
    }

    int newValue = value.toInt();
    if (m_board[index.row()] == newValue) {
        // qDebug() << "Failed to set data: No change in value";
        return false;  // No change in the value
    }

    m_board[index.row()] = newValue;
    emit dataChanged(index, index, {ValueRole});
    checkLevel();

    printBoard();
    return true;
}

void SudokuModel::initBoard() {
    m_board = m_initialBoard;
    emit dataChanged(index(0, 0), index(m_board.size() - 1, 0));
    printBoard();
}

void SudokuModel::resetBoard() {
    m_health = HEALTH;
    m_board = m_initialBoard;
    emit dataChanged(index(0, 0), index(m_board.size() - 1, 0));
}

void SudokuModel::solveBoard() {
    m_board = m_solutionBoard;
    emit dataChanged(index(0, 0), index(m_board.size() - 1, 0));
}

bool SudokuModel::isValidMove(int index, int value) const {
    int tmp;

    qDebug() << "Checking move at index:" << index << "with value:" << value;

    if (index < 0 || index >= BOARD_SIZE * BOARD_SIZE) {
        qDebug() << "Invalid index.";
        return false;
    }

    int row = index / BOARD_SIZE;
    int column = index % BOARD_SIZE;

    qDebug() << "Row:" << row << "Column:" << column;

    // Check row
    for (int col = 0; col < BOARD_SIZE; ++col) {
        tmp = m_board[row * BOARD_SIZE + col];
        if(tmp < 0)
            tmp *= -1;
        if (tmp == value) {
            qDebug() << "Value found in row at column:" << col;
            return false;
        }
    }

    // Check column
    for (int r = 0; r < BOARD_SIZE; ++r) {
        tmp = m_board[r * BOARD_SIZE + column];
        if(tmp < 0)
            tmp *= -1;
        if (tmp == value) {
            qDebug() << "Value found in column at row:" << r;
            return false;
        }
    }

    // Check 3x3 subsquare
    int startRow = (row / 3) * 3;
    int startCol = (column / 3) * 3;
    qDebug() << "Checking subsquare starting at row:" << startRow << "column:" << startCol;

    for (int r = 0; r < 3; ++r) {
        for (int col = 0; col < 3; ++col) {
            tmp = m_board[(startRow + r) * BOARD_SIZE + (startCol + col)];
            if(tmp < 0)
                tmp *= -1;
            if (tmp == value) {
                qDebug() << "Value found in subsquare at row:" << (startRow + r) << "column:" << (startCol + col);
                return false;
            }
        }
    }

    qDebug() << "Move is valid.";
    return true;
}

void SudokuModel::printBoard() {
    qDebug() << "Printing board.";
    for (int i = 0; i < BOARD_SIZE; ++i) {
        QString row;
        for (int j = 0; j < BOARD_SIZE; ++j) {
            row += QString::number(m_board[i * BOARD_SIZE + j]) + " ";
        }
        qDebug() << row;
    }
    qDebug() << "Board printed.";
}

int SudokuModel::health() {
    return m_health;
}

void SudokuModel::decreaseHealth() {
    m_health -= 1;
    if(m_health <0)
        m_health = 0;
    emit healthChanged();
}

void SudokuModel::handleGameStateChanged(QString message) {
    qDebug() << message;
    if (message == "reset") {
        resetBoard();
        m_health = HEALTH;
        emit healthChanged();
        emit gameReset();
    } else if (message == "solve") {
        solveBoard();
    } else if (message == "gameover") {
        resetBoard();
        emit gameReset();
    } else if (message == "nextlevel") {
        m_level += 1;
        m_health = HEALTH;
        emit healthChanged();
        loadSudokuGame(QString::number(m_level));
    } else {
        // TODO
    }
}

void SudokuModel::loadSudokuGame(const QString& level) {
    qDebug() << "loadSudokuGame called with level:" << level;

    QString val;
    QFile file;
    file.setFileName(":/assets/resources/sudoku-games.json");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file:" << file.fileName();
        return;
    }

    val = file.readAll();
    file.close();

    qDebug() << "File content read successfully:" << val;

    // Check if the JSON content is valid
    QJsonParseError jsonError;
    QJsonDocument doc = QJsonDocument::fromJson(val.toUtf8(), &jsonError);

    if (doc.isNull()) {
        qWarning() << "Failed to create QJsonDocument from JSON. Error:" << jsonError.errorString();
        qWarning() << "Raw JSON content:" << val;
        return;
    }

    QJsonObject jsonObject = doc.object();
    if (jsonObject.isEmpty()) {
        qWarning() << "JSON object is empty.";
        return;
    }

    qDebug() << "JSON object parsed successfully.";

    QJsonArray gamesArray = jsonObject["games"].toArray();
    if (gamesArray.isEmpty()) {
        qWarning() << "Games array is empty.";
        return;
    }

    qDebug() << "Total games found:" << gamesArray.size();

    for (const QJsonValue &gameValue : gamesArray) {
        QJsonObject gameObject = gameValue.toObject();
        qDebug() << "Checking level:" << gameObject["level"].toString();
        if (gameObject["level"].toString() == level) {
            qDebug() << "Level match found.";
            QJsonArray initialBoardArray = gameObject["initial_board"].toArray();
            QJsonArray solutionArray = gameObject["solution_board"].toArray();

            m_initialBoard.clear();
            m_board.clear();

            qDebug() << "Loading initial board:";
            for (int i = 0; i < initialBoardArray.size(); ++i) {
                m_initialBoard.append(initialBoardArray[i].toInt());
                m_board.append(initialBoardArray[i].toInt());
                qDebug() << initialBoardArray[i].toInt();
            }

            m_solutionBoard.clear();
            qDebug() << "Loading solution board:";
            for (int i = 0; i < solutionArray.size(); ++i) {
                m_solutionBoard.append(solutionArray[i].toInt());
                qDebug() << solutionArray[i].toInt();
            }

            emit dataChanged(index(0, 0), index(m_board.size() - 1, 0));
            printBoard();
            return;
        }
    }

    qWarning() << "Sudoku game with level" << level << "not found.";
}

void SudokuModel::checkLevel(){
    int zeros = std::count(m_board.begin(), m_board.end(), 0);
    bool gameWin = true;
    if (m_board.size() != m_solutionBoard.size()) {
        gameWin=false;
    }
    for (size_t i = 0; i < m_board.size(); ++i) {
        if (m_board[i] != m_solutionBoard[i]) {
            gameWin=false;
        }
    }

    if(gameWin && m_health > 0)
        emit levelWon();

    qDebug() << " zeros :  "<< zeros;

    if(m_health <=0)
        emit levelFailed();
    qDebug() << " health :  "<< m_health;
}
