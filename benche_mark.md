# UUIDとシーケンスのパフォーマンス比較

## テーブル作成

### **UUIDを主キーとするテーブル**

```sql
CREATE TABLE table_uuid (
    id VARCHAR(36) PRIMARY KEY,
    data VARCHAR(255)
);
```

- `id VARCHAR(36) PRIMARY KEY`: UUIDを格納するためのカラムです。UUIDは36文字の文字列なので、`VARCHAR(36)` を指定します。`PRIMARY KEY` 制約をつけることで、このカラムが主キーとなり、一意な値を保証します。
- `data VARCHAR(255)`:  今回は主キー以外のカラムとして、`data` という名前で `VARCHAR(255)` 型のカラムを追加しました。これはサンプルデータなので、必要に応じてカラム名やデータ型、カラム数を変更してください。

### **シーケンスを主キーとするテーブル**

```sql
CREATE TABLE table_sequence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255)
);
```

- `id INT AUTO_INCREMENT PRIMARY KEY`:  シーケンスを格納するためのカラムです。`INT` 型で十分な大きさです。`AUTO_INCREMENT` を指定することで、自動的に連番が生成されます。`PRIMARY KEY` 制約をつけることで、このカラムが主キーとなり、一意な値を保証します。
- `data VARCHAR(255)`: UUIDを主キーとするテーブルと同様に、サンプルデータとして `data` カラムを追加しました。

## テストデータ

`mysqlslap` を使うと、MySQLサーバーに負荷をかけて、INSERT、SELECT、UPDATE、DELETEといったデータベース操作のパフォーマンスを測定できます。

### 1. INSERTのパフォーマンス測定

大量のデータを挿入する速度を計測します。`mysqlslap` では、`--query` オプションで実行するSQL文を指定し、`--concurrency` オプションで同時接続数を指定します。

```bash
# UUIDを主キーとするテーブルへのINSERT
mysqlslap --user=root --password=P@ssw0rd --concurrency=100 --iterations=10 --query="INSERT INTO table_uuid VALUES (UUID(), 'data')" --create-schema=test

# シーケンスを主キーとするテーブルへのINSERT
mysqlslap --user=root --password=P@ssw0rd --concurrency=100 --iterations=10 --query="INSERT INTO table_sequence VALUES (NULL, 'data')" --create-schema=test
```

上記のコマンドでは、100の同時接続で、それぞれ10回ずつINSERT文を実行し、その平均実行時間を計測します。`--create-schema` オプションで、ベンチマーク用のデータベースを指定します。

## MySQLへの接続

```bash
docker exec -it pk_uuid_vs_sequence-mysql-1 mysql -u root -p
```

