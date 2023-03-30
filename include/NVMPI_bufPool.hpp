#pragma once
#include <queue>
#include <mutex>

template <typename T>
struct NVMPI_bufPool
{	
	std::mutex m_emptyBuf;
	std::mutex m_filledBuf;
	std::queue<T> emptyBuf; //list of buffers available to fill 
	std::queue<T> filledBuf; //filled buffers to consume
	
	T dqEmptyBuf();
	void qEmptyBuf(T buf);
	//Peek at the buffer without dequeuing. Potentially dangerous. Use
	//only in places where simultaneous access to the queue is not possible.
	T peekEmptyBuf();
	
	T dqFilledBuf();
	void qFilledBuf(T buf);
};

template<typename T>
T NVMPI_bufPool<T>::dqEmptyBuf()
{
	T buf = NULL;
	m_emptyBuf.lock();
	if(!emptyBuf.empty())
	{
		buf = emptyBuf.front();
		emptyBuf.pop();
	}
	m_emptyBuf.unlock();
	return buf;
}

template<typename T>
T NVMPI_bufPool<T>::peekEmptyBuf()
{
	T buf = NULL;
	m_emptyBuf.lock();
	if(!emptyBuf.empty())
	{
		buf = emptyBuf.front();
	}
	m_emptyBuf.unlock();
	return buf;
}

template<typename T>
T NVMPI_bufPool<T>::dqFilledBuf()
{
	T buf = NULL;
	m_filledBuf.lock();
	if(!filledBuf.empty())
	{
		buf = filledBuf.front();
		filledBuf.pop();
	}
	m_filledBuf.unlock();
	return buf;
}

template<typename T>
void NVMPI_bufPool<T>::qEmptyBuf(T buf)
{
	m_emptyBuf.lock();
	emptyBuf.push(buf);
	m_emptyBuf.unlock();
	return;
}

template<typename T>
void NVMPI_bufPool<T>::qFilledBuf(T buf)
{
	m_filledBuf.lock();
	filledBuf.push(buf);
	m_filledBuf.unlock();
	return;
}
