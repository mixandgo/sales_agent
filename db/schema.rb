# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_14_061346) do
  create_table "agents", force: :cascade do |t|
    t.string "name"
    t.text "system_prompt"
    t.text "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_chats_on_agent_id"
  end

  create_table "chunks", force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_chunks_on_resource_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "submission_id", null: false
    t.string "role"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_messages_on_submission_id"
  end

  create_table "resource", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.text "input"
    t.text "context"
    t.integer "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_submissions_on_chat_id"
  end

  add_foreign_key "chats", "agents"
  add_foreign_key "chunks", "resources"
  add_foreign_key "messages", "submissions"
  add_foreign_key "submissions", "chats"
end
