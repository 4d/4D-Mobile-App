/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import groovy.lang.Closure
import groovy.lang.GroovyObject
import groovy.lang.MetaClass
import org.codehaus.groovy.runtime.InvokerHelper.getMetaClass
import org.gradle.internal.Cast.uncheckedCast

/**
 * Adapts a Kotlin function to a single argument Groovy [Closure].
 *
 * @param T the expected type of the single argument to the closure.
 * @param action the function to be adapted.
 *
 * @see [KotlinClosure1]
 */
fun <T> Any.closureOf(action: T.() -> Unit): Closure<Any?> =
    KotlinClosure1(action, this, this)

/**
 * Adapts a Kotlin function to a Groovy [Closure] that operates on the
 * configured Closure delegate.
 *
 * @param T the expected type of the delegate argument to the closure.
 * @param action the function to be adapted.
 *
 * @see [KotlinClosure1]
 */
fun <T> Any.delegateClosureOf(action: T.() -> Unit) =
    object : Closure<Unit>(this, this) {
        @Suppress("unused") // to be called dynamically by Groovy
        fun doCall() = uncheckedCast<T>(delegate)?.action()
    }


/**
 * Adapts a parameterless Kotlin function to a parameterless Groovy [Closure].
 *
 * @param V the return type.
 * @param function the function to be adapted.
 * @param owner optional owner of the Closure.
 * @param thisObject optional _this Object_ of the Closure.
 *
 * @see [Closure]
 */
open class KotlinClosure0<V : Any>(
    val function: () -> V?,
    owner: Any? = null,
    thisObject: Any? = null
) : groovy.lang.Closure<V?>(owner, thisObject) {

    @Suppress("unused") // to be called dynamically by Groovy
    fun doCall(): V? = function()
}


/**
 * Adapts an unary Kotlin function to an unary Groovy [Closure].
 *
 * @param T the type of the single argument to the closure.
 * @param V the return type.
 * @param function the function to be adapted.
 * @param owner optional owner of the Closure.
 * @param thisObject optional _this Object_ of the Closure.
 *
 * @see [Closure]
 */
class KotlinClosure1<in T : Any?, V : Any>(
    val function: T.() -> V?,
    owner: Any? = null,
    thisObject: Any? = null
) : Closure<V?>(owner, thisObject) {

    @Suppress("unused") // to be called dynamically by Groovy
    fun doCall(it: T): V? = it.function()
}


/**
 * Adapts a binary Kotlin function to a binary Groovy [Closure].
 *
 * @param T the type of the first argument.
 * @param U the type of the second argument.
 * @param V the return type.
 * @param function the function to be adapted.
 * @param owner optional owner of the Closure.
 * @param thisObject optional _this Object_ of the Closure.
 *
 * @see [Closure]
 */
class KotlinClosure2<in T : Any?, in U : Any?, V : Any>(
    val function: (T, U) -> V?,
    owner: Any? = null,
    thisObject: Any? = null
) : Closure<V?>(owner, thisObject) {

    @Suppress("unused") // to be called dynamically by Groovy
    fun doCall(t: T, u: U): V? = function(t, u)
}


operator fun <T> Closure<T>.invoke(): T = call()


operator fun <T> Closure<T>.invoke(x: Any?): T = call(x)


operator fun <T> Closure<T>.invoke(vararg xs: Any?): T = call(*xs)


/**
 * Executes the given [builder] against this object's [GroovyBuilderScope].
 *
 * @see [GroovyBuilderScope]
 */
inline
fun <T> Any.withGroovyBuilder(builder: GroovyBuilderScope.() -> T): T =
    GroovyBuilderScope.of(this).builder()


/**
 * Provides a dynamic dispatching DSL with Groovy semantics for better integration with
 * plugins that rely on Groovy builders such as the core `maven` plugin.
 *
 * It supports Groovy keyword arguments and arbitrary nesting, for instance, the following Groovy code:
 *
 * ```Groovy
 * repository(url: "scp://repos.mycompany.com/releases") {
 *   authentication(userName: "me", password: "myPassword")
 * }
 * ```
 *
 * Can be mechanically translated to the following Kotlin with the aid of `withGroovyBuilder`:
 *
 * ```Kotlin
 * withGroovyBuilder {
 *   "repository"("url" to "scp://repos.mycompany.com/releases") {
 *     "authentication"("userName" to "me", "password" to "myPassword")
 *   }
 * }
 * ```
 *
 * @see [withGroovyBuilder]
 */
interface GroovyBuilderScope : GroovyObject {

    companion object {

        fun of(value: Any): GroovyBuilderScope =
            when (value) {
                is GroovyObject -> GroovyBuilderScopeForGroovyObject(value)
                else -> GroovyBuilderScopeForRegularObject(value)
            }
    }

    val delegate: Any

    operator fun String.invoke(vararg arguments: Any?): Any?

    operator fun String.invoke(): Any? =
        invoke(*emptyArray<Any>())

    operator fun <T> String.invoke(
        vararg arguments: Any?,
        builder: GroovyBuilderScope.() -> T
    ): Any? =
        invoke(*arguments, closureFor(builder))

    operator fun <T> String.invoke(builder: GroovyBuilderScope.() -> T): Any? =
        invoke(closureFor(builder))

    operator fun <T> String.invoke(
        vararg keywordArguments: Pair<String, Any?>,
        builder: GroovyBuilderScope.() -> T
    ): Any? =
        invoke(keywordArguments.toMap(), closureFor(builder))

    operator fun String.invoke(vararg keywordArguments: Pair<String, Any?>): Any? =
        invoke(keywordArguments.toMap())

    private
    fun <T> closureFor(builder: GroovyBuilderScope.() -> T): Closure<Any?> =
        object : Closure<Any?>(this, this) {
            @Suppress("unused")
            fun doCall() = delegate.withGroovyBuilder(builder)
        }
}


private
class GroovyBuilderScopeForGroovyObject(override val delegate: GroovyObject) : GroovyBuilderScope,
    GroovyObject by delegate {

    override fun String.invoke(vararg arguments: Any?): Any? =
        delegate.invokeMethod(this, arguments)
}


private
class GroovyBuilderScopeForRegularObject(override val delegate: Any) : GroovyBuilderScope {

    private
    val groovyMetaClass: MetaClass by lazy {
        getMetaClass(delegate)
    }

    override fun invokeMethod(name: String, args: Any?): Any? =
        groovyMetaClass.invokeMethod(delegate, name, args)

    override fun setProperty(propertyName: String, newValue: Any?) =
        groovyMetaClass.setProperty(delegate, propertyName, newValue)

    override fun getProperty(propertyName: String): Any =
        groovyMetaClass.getProperty(delegate, propertyName)

    override fun setMetaClass(metaClass: MetaClass?) =
        throw IllegalStateException()

    override fun getMetaClass(): MetaClass =
        groovyMetaClass

    override fun String.invoke(vararg arguments: Any?): Any? =
        groovyMetaClass.invokeMethod(delegate, this, arguments)
}