(ns maat-example.git
  "Namespace that deals with caching and retrieving build/run artifacts from the comparison process"
  (:require
   [clojure.tools.gitlibs :as gl]))

#_{:clj-kondo/ignore [:redefined-var]}
(comment

  (def repo (gl/resolve "git@github.com:doccla/vw-to-ehr-integrations.git"))

  )