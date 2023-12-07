(ns maat-example.maat-example
  (:require
   [clojure.string :as string]
   [clojure.data.csv :as csv]
   [clojure.java.shell :as shell]
   [code-maat.app.app :as maat :exclude [abs]]
   #_[nextjournal.clerk :as clerk]))

(defn run-analysis
  [fname repo-type analysis-type]
  (maat/run fname {:analysis analysis-type,
                   :min-revs 5,
                   :min-shared-revs 5,
                   :min-coupling 30,
                   :max-coupling 100,
                   :max-changeset-size 30,
                   :log fname,
                   :version-control repo-type
                   #_#_:outfile (str "resources/" analysis-type ".csv")}))

(defn csv->map
  [csv-input]
  (let [[headers body] ((juxt #(map keyword (first %)) rest) (csv/read-csv csv-input))]
    (map #(zipmap headers %) body)))

(defn add-analysis
  [fname repo-type m analysis-type]
  (let [analysis (csv->map (with-out-str (run-analysis fname repo-type analysis-type)))]
    (assoc m (keyword analysis-type) analysis)))

(defn run-all-analyses
  [fname repo-type]
  (let [types (-> (maat/analysis-names)
                  (string/split #",")
                  (#(map string/trim %))
                  (#(remove #{"messages"} %))
                  #_(#(take 1 %)))]
    (reduce (partial add-analysis fname repo-type) {} types)))

(defn create-log-file
  [repo-dir fname]
  (->> (shell/with-sh-dir repo-dir
         (shell/sh "git" "log"
                   "--all"
                   "--numstat"
                   "--date=short"
                   "--pretty=format:'--%h--%ad--%aN'"
                   "--no-renames"
                   "--after=1970-01-01"))
       :out
       (spit fname)))



(defn -main
  "I don't do a whole lot ... yet."
  [& args])

(comment

  (def ans
    (run-all-analyses "resources/logfile.log" "git2"))

  (first (run-all-analyses "resources/logfile.log" "git2"))

  (create-log-file "." "tmp.log")

  )



