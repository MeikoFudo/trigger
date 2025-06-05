CREATE TABLE IF NOT EXISTS operation_log (
    id BIGSERIAL PRIMARY KEY,
    username TEXT,
    operation TEXT,
    operation_time TIMESTAMP DEFAULT NOW(),
    table_name TEXT
);

CREATE TABLE IF NOT EXISTS users_log (
    log_id BIGSERIAL PRIMARY KEY,
    id BIGINT,
    name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    operation_id BIGINT REFERENCES operation_log(id)
);

-- Триггеры для таблицы users
CREATE OR REPLACE FUNCTION log_users_insert() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO operation_log(username, operation, table_name)
    VALUES (current_user, 'insert', 'users')
    RETURNING id INTO NEW.operation_id;
    
    INSERT INTO users_log (id, name, email, phone, operation_id)
    VALUES (NEW.id, NEW.name, NEW.email, NEW.phone, NEW.operation_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_users_update() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO operation_log(username, operation, table_name)
    VALUES (current_user, 'update', 'users')
    RETURNING id INTO NEW.operation_id;

    INSERT INTO users_log (id, name, email, phone, operation_id)
    VALUES (NEW.id, NEW.name, NEW.email, NEW.phone, NEW.operation_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_users_delete() RETURNS TRIGGER AS $$
DECLARE op_id BIGINT;
BEGIN
    INSERT INTO operation_log(username, operation, table_name)
    VALUES (current_user, 'delete', 'users')
    RETURNING id INTO op_id;

    INSERT INTO users_log (id, name, email, phone, operation_id)
    VALUES (OLD.id, OLD.name, OLD.email, OLD.phone, op_id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Привязка триггеров
DROP TRIGGER IF EXISTS trg_users_insert ON users;
CREATE TRIGGER trg_users_insert
AFTER INSERT ON users
FOR EACH ROW EXECUTE FUNCTION log_users_insert();

DROP TRIGGER IF EXISTS trg_users_update ON users;
CREATE TRIGGER trg_users_update
AFTER UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION log_users_update();

DROP TRIGGER IF EXISTS trg_users_delete ON users;
CREATE TRIGGER trg_users_delete
AFTER DELETE ON users
FOR EACH ROW EXECUTE FUNCTION log_users_delete();
