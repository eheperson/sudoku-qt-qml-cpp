#ifndef SUDOKUMODEL_H
#define SUDOKUMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QQmlEngine>
#include <QJSEngine>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class SudokuModel : public QAbstractListModel{
    Q_OBJECT
    Q_PROPERTY(int valueRole READ getValueRole CONSTANT)
    Q_PROPERTY(int readOnlyRole READ getReadOnlyRole CONSTANT)
    Q_PROPERTY(int health READ health NOTIFY healthChanged)

public:
    enum Roles {
        ValueRole = Qt::UserRole + 1,
        ReadOnlyRole
    };

    static int getValueRole() { return ValueRole; }
    static int getReadOnlyRole() { return ReadOnlyRole; }

    static QObject* singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    int health();

    Q_INVOKABLE bool isValidMove(int index, int value) const;
    Q_INVOKABLE void decreaseHealth();

signals:
    void healthChanged();
    void levelFailed();
    void levelWon();
    void gameReset();


public slots:
    void handleGameStateChanged(QString message);
    void checkLevel();

protected:
    explicit SudokuModel(QObject *parent = nullptr);

private:
    static constexpr int BOARD_SIZE = 9;
    static constexpr int HEALTH = 5;

    static SudokuModel* m_instance;

    QVector<int> m_board; // Storage for Sudoku values
    QVector<int> m_initialBoard;
    QVector<int> m_solutionBoard;

    int m_health = HEALTH;
    int m_level = 1;

    void printBoard();
    void initBoard();
    void resetBoard();
    void solveBoard();

    void loadSudokuGame(const QString& level) ;
};

#endif // SUDOKUMODEL_H
